module ApplicationHelper
  def nav_active?(test)
    (@navs || []).include?(test.to_s) ? 'active' : ''
  end
end
