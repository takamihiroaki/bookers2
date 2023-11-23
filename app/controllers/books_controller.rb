class BooksController < ApplicationController

  # 以下を追加
  def create
    # １.&2. データを受け取り新規登録するためのインスタンス作成
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
     @book.save
     flash[:notice] = "You have created book successfully."
     redirect_to book_path(@book.id)
    else
      @user = current_user
      @books = Book.all
      render :index
    end
  end

  def index
    @books = Book.all
    @user = User.find(current_user.id)
    @book = Book.new
  end

  def show
    @book = Book.find(params[:id])
    @user = @book.user
    @book_new = Book.new
  end

  def edit
    is_matching_login_user
     @book = Book.find(params[:id])
  end

  def update
    is_matching_login_user
    @book = Book.find(params[:id])

    if @book.update(book_params)
     flash[:notice] = "You have updated book successfully."
     redirect_to book_path(@book.id)
    else

     render :edit
    end
  end

  def destroy
    book = Book.find(params[:id])
    book.destroy
    redirect_to books_path
  end

  private
  # ストロングパラメータ
  def book_params
    params.require(:book).permit(:title, :body)
  end

  def is_matching_login_user
    book = Book.find(params[:id])
    unless book.user.id == current_user.id
      redirect_to books_path
    end
  end
end
