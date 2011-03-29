module ApplicationHelper
  def api_name
    "BoxGrinder REST"
  end

  def api_version
    "0.0.1"
  end

  def entry_points
    [
        [:appliances, appliances_url],
        [:images, images_url],
        [:nodes, nodes_url]
    ]
  end
end
