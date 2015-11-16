module MoviesHelper
  
  # Checks if a number is odd:
  def oddness(count)
    count.odd? ?  "odd" :  "even"
  end
  
  def helper_class(field)
    if(params[:sort].to_s == field)
      return 'hilite'
    else
      return nil
    end
  end
  
  def check_box_helper(field)
    if !session[:sort] and !session[:ratings]
      return true
    end
    if params[:ratings]
      if(params[:ratings][field.to_s])
        return true
      else
        return false
      end
    else
      return false
    end
  end
  
end
