class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]

  def index
    users = User.all
    allowed_sorts = %w[name email access_level]

    users = users.by_name(params[:name]) if params[:name].present?
    users = users.by_email(params[:email]) if params[:email].present?

    if params[:access_level].present? && User.access_levels.key?(params[:access_level])
      users = users.where(access_level: params[:access_level])
    end

    if params[:sort].present? && allowed_sorts.include?(params[:sort])
      direction = params[:direction].to_s.downcase == "desc" ? :desc : :asc
      users = users.order(params[:sort] => direction)
    else
      users = users.order(:id)
    end

    render json: users, status: :ok
  end

  def show
    render json: @user, status: :ok
  end

  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user, status: :created   
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params)
      render json: @user, status: :ok
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    head :no_content
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:external_id, :name, :email, :access_level, :password, :password_confirmation)
  end
end
