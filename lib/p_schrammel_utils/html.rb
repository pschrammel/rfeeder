# -*- encoding : utf-8 -*-
module PSchrammelUtils
  module HTML

    def self.text(html)
      unless html.blank?
        begin
          doc=Nokogiri::HTML(html)
          txt=doc.inner_text
          txt.gsub!(/\s+/, ' ')
          txt.strip!
          return txt
        rescue
          return ''
        end
      else
        return html
      end
    end

  end
end
