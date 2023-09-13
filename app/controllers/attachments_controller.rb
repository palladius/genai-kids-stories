class AttachmentsController < ApplicationController
  before_action :set_attachment, only: %i[regenerate destroy destroy_all regenerate_all]

  # https://stackoverflow.com/questions/49515529/rails-5-2-active-storage-purging-deleting-attachments
  # def delete_image_attachment
  #   @image = ActiveStorage::Blob.find_signed(params[:id])
  #   @image.purge
  #   redirect_to attachments_url
  # end


  def destroy
    # https://stackoverflow.com/questions/49515529/rails-5-2-active-storage-purging-deleting-attachments
    #@image = ActiveStorage::Blob.find_signed(params[:signed_id])
    # if params[:signed_id]
    #   @image = ActiveStorage::Blob.find_signed(params[:signed_id])
    # else
    #   # https://stackoverflow.com/questions/49515529/rails-5-2-active-storage-purging-deleting-attachments
    #   # Answer 28 .3 :)
    #   @image = ActiveStorage::Blob.find(params[:id])
    # end
    @image = ActiveStorage::Blob.find_signed(params[:signed_id])

    puts "DEBUG #AutoSet image: #{ @image }"
    #@ret = @image.purge # doesnt work

    #https://stackoverflow.com/questions/49515529/rails-5-2-active-storage-purging-deleting-attachments
    @ret = @image.attachments.first.purge rescue nil

    #@ret = @image.purge
    puts "DESTROY: ret = #{@ret }"
    #return redirect_to(params[:return_to], notice: 'ReturnTo is valid. Image = @image') if params[:return_to]
    #redirect_to root_path
    #redirect_to '/attachments/destroy', notice: "Nope no return_to, sorry. story: #{@story}. Image: #{@image}. PurgeRet = #{@ret}"
    #redirect_to(stories_url, notice: "Nope no return_to, sorry. story: #{@story}. Image: #{@image}. PurgeRet = #{@ret}" )
    #redirect_to( session.delete(:return_to)) # rescue redirect_to(stories_url)# , notice: 'sobenme'
  end

  # borrowing the regenerate = destroy by signed_id for test
  def regenerate
    # destroy and then fix() :)
    @image = ActiveStorage::Blob.find_signed(params[:signed_id])
    ret = @image.purge! # rescue nil
    return redirect_to(params[:return_to], notice: 'ReturnTo is valid. Image = @image') if params[:return_to]

  end


  private

  # Use callbacks to share common setup or constraints between actions.
  def set_attachment
    #@kid = Kid.find(params[:id])
    if params[:signed_id]
      @image = ActiveStorage::Blob.find_signed(params[:signed_id])
    else
      # https://stackoverflow.com/questions/49515529/rails-5-2-active-storage-purging-deleting-attachments
      # Answer 28 .3 :)
      @image = ActiveStorage::Blob.find(params[:id])
    end
  end

end
