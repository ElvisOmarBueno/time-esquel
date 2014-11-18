class TagsController < ApplicationController
  respond_to :json, :html, :js

  def index

    @all_tags = Post::find_like_tag(params[:term])
    respond_with @all_tags

  end

  def alpha_grouped_index

    permitted = tags_params(params)
    post_type = permitted[:post_type] || "offer"

    @offers_tagged=[]
    @inquiries_tagged=[]

    case post_type
    when "offer"
      @alpha_tags = Offer::alphabetical_grouped_tags
      @current_post_type="offers"
    when "inquiry"
      @alpha_tags = Inquiry::alphabetical_grouped_tags
      @current_post_type="inquiries"
    when "all"
      @alpha_tags = Post::alphabetical_grouped_tags
      @current_post_type="all"
    end

    respond_with @alpha_tags
  end

  def inquiries
    @current_post_type="inquiries"
    @alpha_tags = Inquiry::alphabetical_grouped_tags
    render :partial => 'grouped_index', :locals => { :alpha_tags => @alpha_tags }
  end

  def offers
    @current_post_type="offers"
    @alpha_tags = Offer::alphabetical_grouped_tags
    render :partial => 'grouped_index', :locals => { :alpha_tags => @alpha_tags }
  end

  def posts_with
    permitted = tags_params(params)
    tagname = permitted[:tagname] || ""

    @offers_tagged=Offer::tagged_with(tagname)
    @inquiries_tagged=Inquiry::tagged_with(tagname)
    #render :partial => 'tagged_index', :locals => { :offers_tagged => @offers_tagged,:inquiries_tagged => @inquiries_tagged }
    respond_with @offers_tagged,@inquiries_tagged
  end



  private
  def tags_params(params)
    params.permit(:post_type, :tagname)
  end

end