module ApplicationHelper

  def flash_message
    display_flash_message(:alert) || display_flash_message(:notice)
  end

  private
    def display_flash_message type
      if flash[type]
        content_tag :div, class: type do
          content_tag :p do
             flash[type]
          end
        end
      end
    end
    
end
