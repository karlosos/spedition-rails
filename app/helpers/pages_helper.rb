module PagesHelper
  def tile(text, additional_classes = "")
    div = "
    <div class='col-md-3'>
    <div class='tile #{additional_classes}'>
      #{text}
    </div>
    </div>
    "
  end
end
