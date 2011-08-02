module Tolk
  class SearchesController < Tolk::ApplicationController
    before_filter :find_locale, :find_from_locale
  
    def show
      @phrases = @locale.search_phrases(params[:q], params[:scope].to_sym, params[:k], params[:page])
    end

    private

    def find_locale
      @locale = Tolk::Locale.find_by_name!(params[:locale])
    end
    
    def find_from_locale
      @from_locale = Tolk::Locale.find_by_name(params[:from_locale]) || Tolk::Locale.find_by_name(cookies['tolk_from_locale']) || Tolk::Locale.primary_locale
      cookies['tolk_from_locale'] = params[:from_locale] if params[:from_locale]
    end
  end
end
