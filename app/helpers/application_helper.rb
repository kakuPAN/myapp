module ApplicationHelper
  # frozen_string_literal: true
  def default_meta_tags
    {
      site: "TopicBoard",
      title: "TopicBoard",
      reverse: true,
      charset: "utf-8",
      description: "みんなで作る掲示板サイトです",
      canonical: request.original_url,
      og: {
        site_name: "TopicBoard",
        title: "TopicBoard",
        description: "みんなで作る掲示板サイトです",
        type: "website",
        url: request.original_url,
        image: image_url("free_images/sakura.png"),
        local: "ja-JP"
      },
      twitter: {
        card: "summary_large_image",
        site: "@V7wMYdaO8s14160",
        image: image_url("free_images/sakura.png")
      }
    }
  end

  def page_title(title = '', admin: false)
    base_title = admin ? 'Topic Board Admin' : "Topic Board"
    title.present? ? "#{title} | #{base_title}" : base_title
  end
end
