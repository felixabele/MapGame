module ApplicationHelper
  
  
  # ==========================================
  #   Glycos-Icon-Helper
  # ==========================================
  # --- Icon
  def icon_for( label, icon, color='' )
    if color == 'white' then icon << ' icon-white' end
    "<i class='#{icon}'></i> #{label}</a>".html_safe
  end
  
end
