module Tolk
  class LocalesController < Tolk::ApplicationController
    before_filter :find_locale, :only => [:show, :all, :update, :updated]
    before_filter :find_from_locale, :only => [:show, :all]
    before_filter :ensure_no_primary_locale, :only => [:all, :update, :show, :updated]
    before_filter :update_per_page, :only => [:all, :show, :updated]

    def index
      @locales = Tolk::Locale.secondary_locales
      
      @primary_key_scopes = []
      if params[:details] == "true"
        @primary_key_scopes = Tolk::Phrase.all(:order => 'tolk_phrases.key ASC').collect{|phrase| phrase.key.split('.').first}.uniq
      end
    end
  
    def show      
      respond_to do |format|
        format.html do
          @phrases = @locale.phrases_without_translation(params[:page])
        end
        format.atom { @phrases = @locale.phrases_without_translation(params[:page], :per_page => 50) }
        format.yml { render :text => @locale.to_hash.ya2yaml(:syck_compatible => true) }
      end
    end

    def update
      @locale.translations_attributes = params[:translations] if params[:translations]
      @locale.description = params[:description] if params[:description]
      @locale.save
      redirect_to request.referrer
    end

    def all
      @phrases = @locale.phrases_with_translation(params[:page])
    end

    def updated
      @phrases = @locale.phrases_with_updated_translation(params[:page])
      render :all
    end

    def create
      Tolk::Locale.create!(params[:tolk_locale])
      redirect_to :action => :index
    end

    private

    def find_locale
      @locale = Tolk::Locale.find_by_name!(params[:id])
    end

    def find_from_locale
      @from_locale = Tolk::Locale.find_by_name(params[:from_locale]) || Tolk::Locale.find_by_name(cookies['tolk_from_locale']) || Tolk::Locale.primary_locale
      cookies['tolk_from_locale'] = params[:from_locale] if params[:from_locale]
    end

    def update_per_page
      if params[:per_page]
        params[:per_page] = 9999999 if params[:per_page] == "all"
        Tolk::Phrase.per_page = params[:per_page].to_i if params[:per_page].to_i > 0
      end
    end
  end
end
