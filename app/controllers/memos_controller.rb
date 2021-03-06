class MemosController < ApplicationController
  before_action :require_user_logged_in
  before_action :correct_user, only: [:destroy]


  def index
      @memos = Memo.all.order('created_at DESC').page(params[:page])
      @memo = current_user.memos.build
      @user = current_user
  end

  def new
      @memo = current_user.memos.build  # form_for 用
      @memos = current_user.memos.order('created_at DESC').page(params[:page])
  end

  def create
    @user = current_user
    @memo = current_user.memos.build(memo_params)
    if @memo.save
      flash[:success] = 'メモを追加しました。'
      redirect_back(fallback_location: root_path)
    else
      @memos = current_user.memos.order('created_at DESC').page(params[:page])
      flash.now[:danger] = 'メモの追加に失敗しました。'
      render 'memos/new'
    end
  end

  def destroy
    @memo.destroy
    flash[:danger] = 'メモを削除しました。'
    redirect_back(fallback_location: root_path)
  end

  def edit
    @memo = Memo.find(params[:id])
  end

  def update
    @memo = Memo.find(params[:id])

    if @memo.update(memo_params)
      flash[:success] = 'メモは正常に更新されました'
      redirect_to current_user
    else
      flash.now[:danger] = 'メモは更新されませんでした'
      render :edit
    end
  end

   private

  def memo_params
    params.require(:memo).permit(:trick, :content)
  end

  def correct_user
    @memo = current_user.memos.find_by(id: params[:id])
    unless @memo
      redirect_to root_url
    end
  end
end
