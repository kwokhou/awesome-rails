class HomeController < ApplicationController
  def index
    render body: "Yep, I'm working...#{ENV["APP_MESSAGE"]}"
  end
end
