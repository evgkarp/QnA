class AttachmentSerializer < ActiveModel::Serializer
  attributes :url, :filename

  def filename
    object.file.identifier
  end

  def url
    object.file.url
  end
end
