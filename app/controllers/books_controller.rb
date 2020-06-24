class BooksController < ApplicationController
  before_action :authenticate_user!

  def show
  	@book = Book.find(params[:id])
    @newbook = Book.new
    @user = @book.user
  end

  def index
  	@books = Book.all #一覧表示するためにBookモデルの情報を全てくださいのall
    @book = Book.new
    @user = current_user
  end

  def create
  	book = Book.new(book_params) #Bookモデルのテーブルを使用しているのでbookコントローラで保存する。
    book.user_id = current_user.id
  	if book.save #入力されたデータをdbに保存する。
      flash[:notice] = "Book was successfully created."
      redirect_to book_path(book.id)#保存された場合の移動先を指定。
  	else
      @books = Book.all
      @book = book
      @user = current_user
  		render 'index'
  	end
  end

  def edit
  	@book = Book.find(params[:id])
  end



  def update
  	@book = Book.find(params[:id])
  	if @book.update(book_params)
  		  flash[:notice] = "Book was successfully updated."
        redirect_to book_path(@book.id)
  	else #if文でエラー発生時と正常時のリンク先を枝分かれにしている。
      @books = Book.all
  		render "edit"
  	end
  end

  def destroy
   book = Book.find(params[:id])
   if book.destroy
    flash[:notice] = "Book was successfully destroyed."
    redirect_to books_path
   else
   books = Book.all
   render 'index'
  end
  end

  private
  def book_params
  	params.require(:book).permit(:title, :body)
  end
  def ensure_corrent_user
        @book = Book.find_by(id: params[:id])
        if @book.user_id != current_user.id
            redirect_to books_path
        end
  end
end
