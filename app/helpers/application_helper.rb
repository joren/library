module ApplicationHelper
  def bootstrap_notice_type(type)
    case type
    when "notice" then "alert-info"
    when "error"  then "alert-danger"
    else
      "alert-dark"
    end
  end
end
