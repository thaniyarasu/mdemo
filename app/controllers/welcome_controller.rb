class WelcomeController < ApplicationController
  def index
  end

  def invite
    @invite = Invite.new(invite_params)
    if invite_params[:document] && invite_params[:document].original_filename.empty?
      @invite.document = invite_params[:document]
    end

    respond_to do |format|
      if @invite.save
        format.html { redirect_to action: :select ,id: @invite }
        format.json { render :show, status: :created, location: @invite }
      else
        format.html { render :index }
        format.json { render json: @invite.errors, status: :unprocessable_entity }
      end
    end
  end

  def select
    @invite = Invite.find(params[:id])
    @parser = @invite.parser
  end



  private

  def invite_params
    params.require(:invite).permit(:name, :document)
  end
end

#http://stackoverflow.com/questions/10878851/im-using-the-ruby-gem-roo-to-read-xlsx-file-how-to-return-the-content-of-one
#http://stackoverflow.com/questions/6766129/using-column-headers-to-parse-excel-sheets-using-roo-ruby
