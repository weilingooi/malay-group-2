class CoursesController < ApplicationController
  before_action :set_course, except: %i(new create show)
  before_action :authenticate_user!
  before_action :check_permitted_or_not , only: %i(edit destroy)

  def index
    @courses = Course.recent_courses.page params[:page]
  end

  def show; end

  def new
    @course = Course.new
  end

  def edit; end

  def create
    @course = Course.new　course_params
    @course.user_id = current_user.id

    respond_to do |format|
      if @course.save
        format.html { redirect_to @course, notice: t("controller.course.create") }
        format.json { render :show, status: :created, location: @course }
      else
        format.html { render :new }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end 

  def update
    respond_to do |format|
      if @course.update(course_params)
        format.html { redirect_to @course, notice: t("controller.course.updated") }
        format.json { render :show, status: :ok, location: @course }
      else
        format.html { render :edit }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @course.destroy
        format.html { redirect_to courses_path, notice: t("controller.course.destroy") }
        format.json { head :no_content }
      else
        format.html {redirect_to courses_path, notice: t("controller.course.not_destroy")}
        format.json { head :no_content }
    end
  end

  private

  def course_params
    params.require :course.permit :title,:user_id
  end

  def set_course
    @course = Course.find_by(params[:user_id])
    return if @course

    flash[:warning] = t"not_found"
    redirect_to root_path
  end

  def check_permitted_or_not
    if current_user
      if @course.try(:user).try(:id) != current_user.id
        redirect_to courses_path()
      end
    end
  end
  
  def authenticate_user!
    if current_user
      session[:user_id] = current_user.id
      render json: {
        status: :created,
        logged_in: true,
        user: user
      }
    else
      render json: { status: 401 }
    end
  end
  
  def check_permitted_manage_courses_or_not
    redirect_to courses_path if current_user.usertype == 1
      redirect_to courses_path
    end
  end
end