defmodule Iso8583Monitor.Utils do
  @moduledoc """
  this module is for a sample utility module for utility functions
  """
  @page_size 5

  def get_offset(page) do
    (page - 1) * @page_size
  end

  def get_page_size do
    @page_size
  end

  def add_page_info(page) do
    get_offset(page)    
  end

  def paginate(page,row_count) do
    case {page,row_count} do
      {page,row_count} when page == 1 and row_count == @page_size -> %{cpage: 1, next_page_show: true}
      {page,row_count} when page == 1 and row_count <  @page_size -> %{cpage: 1, next_page_show: false}
      {page,row_count} when page >  1 and row_count == @page_size -> %{cpage: page,next_page_show: true}
      {page,row_count} when page >  1 and row_count < @page_size  -> %{cpage: page,next_page_show: false}
    end
  end
	
end
