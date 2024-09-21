class HiraganasController < ApplicationController
  def index
    @hiraganas = Hiragana.all
  end

  def show
    @hiragana = Hiragana.includes(:building_blocks).find(params[:id])
  end

  def new
    @hiragana = Hiragana.new
  end

  def create
    @hiragana = Hiragana.new(hiragana_params)
    if @hiragana.save
      redirect_to @hiragana, notice: "Hiragana was successfully created."
    else
      render :new
    end
  end

  def edit
    @hiragana = Hiragana.find(params[:id])
  end

  def update
    @hiragana = Hiragana.find(params[:id])
    if @hiragana.update(hiragana_params)
      redirect_to @hiragana, notice: "Hiragana was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @hiragana = Hiragana.find(params[:id])
    @hiragana.destroy
    redirect_to hiraganas_url, notice: "Hiragana was successfully destroyed."
  end

  private

  def hiragana_params
    params.require(:hiragana).permit(:name, :memo, :story, :translated_name, :image, :story_image, building_block_ids: [])
  end
end
