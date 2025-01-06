class OauthsController < ApplicationController
 # sends the user on a trip to the provider,
 # and after authorizing there back to the callback url.
 def oauth
   login_at(params[:provider])
 end

 def callback
   provider = params[:provider]
   if @user = login_from(provider)
     redirect_to user_path(@user)
     flash[:success] = "#{provider.titleize}!でログイン"
   else
     begin
       @user = create_from(provider)
       # NOTE: this is the place to add '@user.activate!' if you are using user_activation submodule

       reset_session # protect from session fixation attack
       auto_login(@user)
       redirect_to edit_user_path(@user)
       flash[:success] = "#{provider.titleize}!からアカウントを作成します"
     rescue
       redirect_to login_path
       flash[:danger] = "#{provider.titleize}!でのアカウント作成に失敗しました"
     end
   end
 end

 #example for Rails 4: add private method below and use "auth_params[:provider]" in place of
 #"params[:provider] above.

 # private

 # def auth_params
 #   params.permit(:code, :provider)
 # end

end
