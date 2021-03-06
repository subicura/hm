class SessionsController < ApplicationController
  def new
  end

  def create
    user = if params[:session][:email_username] =~ /@/
             Parent.find_by_email(params[:session][:email_username].downcase)
           else
              Child.find_by_username(params[:session][:email_username].downcase)
           end

    if user && user.authenticate(params[:session][:password])
      sign_in user
    

      if user.class == Parent
        Mixpanel.simple_track('Parent sign in', {'distinct_id' => user.id})
        redirect_back_or parent_dash_path
      else
        Mixpanel.simple_track('Child sign in', {'distinct_id' => user.id})
        redirect_back_or child_dash_path
      end
    else
      redirect_to root_path, flash: { error: 'Invalid email or username/password combination' }
    end
  end

  def destroy
    sign_out 
    redirect_to root_path
  end
end
