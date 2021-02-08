class CommentsController < ApplicationController
  before_action :set_comment, only: [:destroy]
  before_action :set_event, only: [:create, :destroy]

  # POST /comments
  def create
    # Создаём объект @new_comment из @event
    @new_comment = @event.comments.build(comment_params)
    # Проставляем пользователя, если он задан
    @new_comment.user = current_user

    if @new_comment.save
      # Если сохранился, редирект на страницу самого события
      redirect_to @event, notice: I18n.t('controllers.comments.created')
    else
      # Если ошибки — рендерим здесь же шаблон события (своих шаблонов у коммента нет)
      render 'events/show', alert: I18n.t('controllers.comments.error')
    end
  end

  # DELETE /comments/1
  def destroy
    message = { notice: I18n.t('controllers.comments.destroyed') }

    if current_user_can_edit?(@comment)
      @comment.destroy!
    else
      message = { alert: I18n.t('controllers.comments.error') }
    end

    redirect_to @event, message
  end

  # PATCH/PUT /comments/1
  # def update
  #   if @comment.update(comment_params)
  #     redirect_to @comment, notice: 'Comment was successfully updated.'
  #   else
  #     render :edit
  #   end
  # end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def set_event
    @event = Event.find(params[:event_id])
  end

  def set_comment
    @comment = @event.comments.find(params[:id])
  end
end
