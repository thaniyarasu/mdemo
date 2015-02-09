class EmailsController < ApplicationController
  before_action :set_email, only: [:show, :edit, :update, :destroy]

  # GET /emails
  # GET /emails.json
  def index

    @emails = Email.all
    #redirect_to invites_path

  end

  # GET /emails/1
  # GET /emails/1.json
  def show
  end

  # GET /emails/new
  def new
    @email = Email.new
    if !invite_params[:id].to_i.zero? && !invite_params[:selected].nil? && !invite_params[:selected].empty?
      @invite = Invite.find(invite_params[:id])
      ids = invite_params[:selected].collect{|e| e.to_i-1 }
      emails = @invite.parse("email",ids)
      @email.recipients = emails.join(',')
      phones = @invite.parse("phone",ids)
      audios = @invite.parse("audio",ids)
      voices = @invite.parse("voice",ids)


      @email.call =  <<STRING
say "Calling you now, please wait."
transfer "+#{phones[0]}"
STRING
      @email.audio =  <<STRING
say "Please wait while we transfer your call. Press star to cancel the transfer."
transfer ["+#{phones[0]}","sip:12345678912@127.0.0.1"], {
   :playvalue => "#{audios[0]}",
   :terminator => "*",
   :onTimeout => lambda { |event|
      say "Sorry, but nobody answered"
   }
STRING
      @email.voice =  <<STRING
event = call "+#{phones[0]}"
event.value.say "#{voices[0]}!!"
STRING






      end
  end

  # GET /emails/1/edit
  def edit
  end

  # POST /emails
  # POST /emails.json
  def create
    @email = Email.new(email_params)

    respond_to do |format|
      if @email.save
        if @email.recipients
          recipients = @email.recipients.split(",")
          recipients.each { |r|
            Notifications.notify(r,@email.subject,@email.message).deliver_now
          }
        end


        format.html { redirect_to @email, notice: 'Email was successfully created.' }
        format.json { render :show, status: :created, location: @email }
      else
        format.html { render :new }
        format.json { render json: @email.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /emails/1
  # PATCH/PUT /emails/1.json
  def update
    respond_to do |format|
      if @email.update(email_params)
        format.html { redirect_to @email, notice: 'Email was successfully updated.' }
        format.json { render :show, status: :ok, location: @email }
      else
        format.html { render :edit }
        format.json { render json: @email.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /emails/1
  # DELETE /emails/1.json
  def destroy
    @email.destroy
    respond_to do |format|
      format.html { redirect_to emails_url, notice: 'Email was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_email
      @email = Email.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def email_params
      params.require(:email).permit(:subject, :message, :recipients,:call,:audio,:voice)
    end
    def invite_params
      params.require(:invite).permit(:id,selected: [])
    end
end
