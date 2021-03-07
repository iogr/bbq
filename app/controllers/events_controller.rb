class EventsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  before_action :set_event, only: [:show]
  before_action :set_current_user_event, only: [:edit, :update, :destroy]

  after_action :verify_authorized, only: [:destroy]

  # GET /events
  def index
    @events = Event.all
  end

  # GET /events/1
  def show
    authorize @event
    @new_comment = @event.comments.build(params[:comment])
    @new_subscription = @event.subscriptions.build(params[:subscription])

    # Болванка модели для формы добавления фотографии
    @new_photo = @event.photos.build(params[:photo])
  end

  # GET /events/1/edit
  def edit
    authorize @event
  end

  # GET /events/new
  def new
    @event = current_user.events.build
  end

  # POST /events
  def create
    @event = current_user.events.build(event_params)
    authorize @event

    if @event.save
      redirect_to @event, notice: 'Event was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /events/1
  def update
    authorize @event

    if @event.update(event_params)
      redirect_to @event, notice: 'Event was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /events/1
  def destroy
    authorize @event
    @event.destroy
    redirect_to events_url, notice: 'Event was successfully destroyed.'
  end

  private

  def set_current_user_event
    @event = current_user.events.find(params[:id])
  end

  def set_event
    @event = Event.find(params[:id])
  end

  # редактируем параметры события
  def event_params
    params.require(:event).permit(:title, :address, :datetime, :description)
  end
end
