module ActivitiesHelper

  def render_activities(name, partial = nil)
    if partial.nil?
      render send("#{name}_activities")
    else
      render :partial => partial, :collection => send("#{name}_activities")
    end
  end

  def app_activities
    @activities = Activity.order('created_at desc')
      .where('user_id IS NOT ?', nil).includes(:item, :site, :user).limit(20)
  end

  def site_activities
    @activities = Activity.order('created_at desc')
      .where('site_id = ? AND user_id IS NOT ?', current_site.id, nil)
      .includes(:item, :site, :user).limit(20)
  end

  def activity_content(activity)
    o  = content_tag(:span, "#{activity.user.display_name}", :class => 'user')
    o += " #{activity.action} #{activity.item_type.underscore.humanize.downcase} "
    o += link_to("#{activity.item.title}", activity.item_path, :class => 'item')
  end

end