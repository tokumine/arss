#Final resting place of the stories
class ArssStory

  attr_accessor :title, :published_date, :text

  def full_title
    "#{published_date}: #{title}"
  end
end
