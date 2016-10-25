class DocumentsController < ApplicationController
  def index
    @documents = Document.all
  end

  def new
    @document = Document.new
  end

  def create
    @document = Document.new(document_params)
    if @document.save
      @group.add(@document)
      redirect_to documents_path, notice: "Dokument #{@document.name} zostal zapisany"
    else
      render "new"
    end
  end

  def destroy
    @document = Document.find(params[:id])
    @document.destroy
    redirect_to documents_path, notice: "Dokument #{@document.name} zostal usuniety"
  end

  private
  def document_params
    params.require(:document).permit(:name, :attachment)
  end
end
