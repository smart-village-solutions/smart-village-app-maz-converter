# frozen_string_literal: true

class ContentBlockParser
  def self.perform(data)
    content_blocks = []
    content_blocks << parse_single_content_block(data)
  end

  private

    def self.parse_single_content_block(data)
      {
        title: data["title"]["value"],
        intro: data["intro"]["value"],
        body: data["body"]["value"],
        media_contents: media_contents(data)
      }
    end

    def self.media_contents(data)
      media = []
      media << article_image(data)
      media << related_objects_images(data)
      media.compact.flatten
    end

    #
    # Bilder kommen bei der Maz zum einen aus den keys die mit article images beginnen.
    # diese Methode parsed dieses article image in ein media content object
    #
    # @param [<Type>] data <description>
    #
    # @return [<Type>] <description>
    #
    def self.article_image(data)
      {
        content_type: "image",
        copyright: data["article_image_photographer"]["value"],
        caption: data["article_image_caption"]["value"],
        width: data["article_image"]["value"]["width"],
        height: data["article_image"]["value"]["height"],
        source_url: {
          url: data["article_image"]["value"]["url"]
        }
      }
    end

    #
    # Bilder kommen bei der Maz zum einen aus ddem images array der sich
    # im related_objects array befindet.
    # diese Methode parsed diese images in je ein media content object.
    #
    # @param [<Type>] data <description>
    #
    # @return [<Type>] <description>
    #
    def self.related_objects_images(data)
      data["related_objects"].first["images"].map do |image|
        {
          content_type: image["caption"]["value"],
          copyright: image["photographer"]["value"],
          width: image["image"]["value"]["width"],
          height: image["image"]["value"]["height"],
          source_url: {
            url: image["image"]["value"]["url"]
          }
        }
      end
    end
end
