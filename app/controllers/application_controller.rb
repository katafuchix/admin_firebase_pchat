require "google/cloud/firestore"

class ApplicationController < ActionController::Base
  before_action :set_sakura

  private

  def set_sakura
    $sakuras = Firestore::LoginUser.sakura if $sakuras.nil?
  end
end
