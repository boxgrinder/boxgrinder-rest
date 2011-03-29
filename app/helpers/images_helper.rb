module ImagesHelper
  def available_events
    Image.state_machines[:default].events_for(@image.current_state).reject { |event| event.eql?(:error) }
  end
end
