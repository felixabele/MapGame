
# Humanize Numbers (http://teamco-anthill.blogspot.de/2008/10/humanize-numbers-with-ruby.html)
class Numeric
    def humanize(rounding=2,delimiter=',',separator='.')
      value = respond_to?(:round_with_precision) ? round(rounding) : self
 
      #see number with delimeter
      parts = value.to_s.split('.')
      parts[0].gsub!(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1#{delimiter}")
      parts.join separator
    end
end