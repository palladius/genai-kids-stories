class AttachmentsController < ApplicationController

  # https://stackoverflow.com/questions/49515529/rails-5-2-active-storage-purging-deleting-attachments
  # def delete_image_attachment
  #   @image = ActiveStorage::Blob.find_signed(params[:id])
  #   @image.purge
  #   redirect_to attachments_url
  # end


  def destroy
    # https://stackoverflow.com/questions/49515529/rails-5-2-active-storage-purging-deleting-attachments
    #@image = ActiveStorage::Blob.find_signed(params[:signed_id])
    @image = ActiveStorage::Blob.find_signed(params[:signed_id])
    ret = @image.purge rescue nil
    #redirect_to(stories_url, notice: 'sobenme' )
    redirect_to( session.delete(:return_to)) rescue redirect_to(stories_url)# , notice: 'sobenme'
  end

  def regenerate
    # destroy and then fix() :)
  end

end
