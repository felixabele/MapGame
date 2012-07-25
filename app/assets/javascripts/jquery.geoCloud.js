// jQuery Geo-Cloud-Plugin
// Country Map with custum Elements
// version 0.6, 25.07.2012
// by Felix Abele

(function($) {

    // ---> GeoCloud-Plugin Start
    $.geocloud = function(element, options) {

        var $element = $(element),
             element = element,
             canvas_ctx = null;

        // --- Default-Options
        var defaults = {            
            element: $element,
            geo_settings: {
              x_corr:   0.00, // x-Curvation-Fix Value
              y_corr:   0.00, // y-Curvation-Fix Value
              coef:     0.00  // Coordinate-Pixel Coefficient
            },
            ref_point: {
              pixel_point: [200, 200],  // Reference Point (Pixel)
              coord: [0.00, 0.00]       // ... Geo-Coordinates
            },
            map_src: 'maps/default.jpg',// Map-Source
            use_canvas: false,          // false, true
            canvas_style_opt: {
                fillStyle: "#8ED6FF", lineWidth: 1, strokeStyle: "grey"}
        }

        // use "plugin" to reference the current instance of the object
        var plugin = this;

        // Plugin-Settings
        plugin.settings = {}


        // ----------------------------------------
        //      INITIALISATION
        // ----------------------------------------
        // the "constructor" method that gets called when the object is created
        plugin.init = function() {
            // Extend Default-Settings with Customs
            plugin.settings = $.extend({}, defaults, options);
            plugin.element = $element;            
            
            // Canvas Options
            if ((plugin.settings.use_canvas)) {
                var canvas = $( "<canvas></canvas>" );                
                canvas.attr('width', plugin.settings.width);
                canvas.attr('height', plugin.settings.height);
                plugin.settings.use_canvas = true;
                plugin.canvas_ctx = canvas[0].getContext('2d');
                plugin.element.append(canvas);
            }            
            
            // Draw the Map
            $element.css({
                'background-image': 'url('+ plugin.settings.map_src +')',
                'width': plugin.settings.width, 
                'height': plugin.settings.height,
                'position': 'relative'
            });
            $element.addClass('geo_cloud');
        }


        // ----------------------------------------
        //      Public Methods
        // ----------------------------------------
        // --- Draw A Point
        //     @params: 
        //          city = {'title': 'Roma', 'pixel_point': [363, 549], 'coord': [12.4942486, 41.8905198]}
        //          opt  = {'attr': {}, 'css': {}, events {'onClick': function(){}}}
        plugin.drawPoint = function( city, opt ) {                        
            
            // Set opt to default if unset
            if (!opt) { var opt = {} }
            var bs_opt = {css: {}, events: {}, attr: {}};            
            opt = $.extend({}, bs_opt, opt)
            
            // get Pixel-Point from Geo-Point
            var point = get_by_reference( city.coord ),
                dot = $( '<div></div>' ),
                rad = city.size/2,
                x = parseInt( point[0]-rad ),
                y = parseInt( point[1]-rad ),
                styles = $.extend({}, {
                    'left': x, 'bottom': y, 'height': city.size, 'width': city.size, 
                    'border-radius':rad+2, 'position': 'absolute'}, 
                    opt.css),
                attrs = $.extend({}, {'title': city.title}, city.attr, opt.attr);            
            
            dot.css(styles);
            dot.attr(attrs);
            
            // Bind Listeners            
            $.each(opt.events, function(type, fn) { 
                dot.bind(type, {city: city}, fn);
            });
            plugin.element.append(dot);
            
            // Draw Point on Canvas: Makes no sense for Now, but maybe for the future
            /*if (plugin.settings.use_canvas) {
                plugin.canvas_ctx.beginPath();
                plugin.canvas_ctx.arc(point[0], plugin.settings.height-point[1], rad, 0 , 2 * Math.PI, false);
                plugin.canvas_ctx.fillStyle = plugin.settings.canvas_style_opt.fillStyle;
                plugin.canvas_ctx.fill();   
                plugin.canvas_ctx.lineWidth = plugin.settings.canvas_style_opt.lineWidth;
                plugin.canvas_ctx.strokeStyle = plugin.settings.canvas_style_opt.strokeStyle;
                plugin.canvas_ctx.stroke();                
            }*/           
            
            return dot;
        }
        
        // --- Draw an Array of points
        plugin.drawPoints = function( cities, opt ) {
            for(var i=0; i<cities.length; i++) {                
                plugin.drawPoint(cities[i], opt);
            }
        }

        // --- Draw A Line By Name (Only if Canvas is enabled)
        //     @params: 
        //          from = 'Berlin'
        //          to   = 'Hamburg'
        plugin.drawLineByNames = function( from, to ) {
            var el1 = plugin.element.find('[title="'+ from +'"]'),
                el2 = plugin.element.find('[title="'+ to +'"]');
            drawCanvasLine( 
                {pos: el1.position(), rad: parseInt(el1.width()/2)},
                {pos: el2.position(), rad: parseInt(el2.width()/2)}
           );
        }

        // --- Draw A Line By points (Only if Canvas is enabled)
        //     Returns: Distance in Km
        //     @params: 
        //          p1 = {title: 'Toulouse', size: 13, coord: [1.444209, 43.604652]},            
        //          p2 = {title: 'Perpignan',size: 8, coord: [2.8958719, 42.698684]}
        plugin.drawLine = function( p1, p2 ) {
            plugin.drawLineByNames( p1.title, p2.title );
            return plugin.getDistance( p1, p2 );
        }
        
        // --- Get Distance in Km
        //     @params: 
        //          p1 = {title: 'Toulouse', size: 13, coord: [1.444209, 43.604652]},            
        //          p2 = {title: 'Perpignan',size: 8, coord: [2.8958719, 42.698684]}
        plugin.getDistance = function( p1, p2 ) {
            var lat1  = (p1.coord[1] / 180 * Math.PI),
                len1  = (p1.coord[0] / 180 * Math.PI),
                lat2  = (p2.coord[1] / 180 * Math.PI),
                len2  = (p2.coord[0] / 180 * Math.PI);
            var e = Math.acos( Math.sin(lat1)*Math.sin(lat2) + Math.cos(lat1)*Math.cos(lat2)*Math.cos(len2-len1) );
            return parseInt(e * 6378.137);
        }
        
        // --- Get Geopoint from Pixel
        //    @param: point = [120, 300]
        plugin.pixelsToCoords = function( pixel_point ) {
          
            var coef = plugin.settings.geo_settings.coef,
                ref_p = plugin.settings.ref_point;          
          
            // Calculate distance to reference point in Pixel
            var px_x_diff = (ref_p.pixel_point[0]-pixel_point[0])*coef,
                px_y_diff = (ref_p.pixel_point[1]-pixel_point[1])*coef;  
            
            // transform it to grad
            var geo_x = ref_p.coord[0] - (px_x_diff / plugin.settings.geo_settings.x_corr),
                geo_y = ref_p.coord[1] - (px_y_diff / plugin.settings.geo_settings.y_corr);
            
            return [geo_x, geo_y]
        }

        // --- Get Geopoint from Pixel
        //    @param: point = [1.444209, 43.604652]
        plugin.coordsToPixels = function( geo_point ) {
            return get_by_reference( geo_point );
        }

        // ----------------------------------------
        //      Private Methods
        // ----------------------------------------
        // --- Calculate Point in pixel by Reference Geo-Value
        var get_by_reference = function(coords) {
            var coef = plugin.settings.geo_settings.coef,
                ref_p = plugin.settings.ref_point;
            
            var gr_lng_diff = coords[0]-ref_p.coord[0],
                gr_lat_diff = coords[1]-ref_p.coord[1];

            var px_x_diff = gr_lng_diff/coef,
                px_y_diff = gr_lat_diff/coef;  

            // correcten for the Earth is an elypsis
            px_x_diff *= plugin.settings.geo_settings.x_corr;
            px_y_diff *= plugin.settings.geo_settings.y_corr;

            var px_x = ref_p.pixel_point[0] + px_x_diff,
                px_y = ref_p.pixel_point[1] + px_y_diff;      

            return [parseInt(px_x), parseInt(px_y)];
        }
        
        // --- Draw A Line between two points on Canvas-Element
        var drawCanvasLine = function( p1, p2 ) {
            if (plugin.settings.use_canvas) {
                plugin.canvas_ctx.beginPath();
                plugin.canvas_ctx.moveTo((p1.pos.left+p1.rad), (p1.pos.top+p1.rad));
                plugin.canvas_ctx.lineTo((p2.pos.left+p2.rad), (p2.pos.top+p2.rad));
                plugin.canvas_ctx.strokeStyle = plugin.settings.canvas_style_opt.fillStyle;
                plugin.canvas_ctx.lineWidth = plugin.settings.canvas_style_opt.lineWidth;
                
                plugin.canvas_ctx.stroke();                
            }            
        }

        // fire up the plugin!
        // call the "constructor" method
        plugin.init();
    }

    // add the plugin to the jQuery.fn object
    $.fn.geocloud = function(options) {
        return this.each(function() {
            if (undefined == $(this).data('geocloud')) {

                var plugin = new $.geocloud(this, options);
                $(this).data('geocloud', plugin);
            }
        });
    }
})(jQuery);