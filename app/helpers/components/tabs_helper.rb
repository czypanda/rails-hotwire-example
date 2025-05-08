module Components::TabsHelper
    def render_tabs(**options, &block)
      @_tabs = []
      capture(&block)
      render "components/ui/tabs", options: options
    end
  
    def tab_list(&block)
      content_for :tab_list, capture(&block), flush: true
    end

    def before_tab_list(&block)
      content_for :before_tab_list, capture(&block), flush: true
    end

    def after_tab_list(&block)
      content_for :after_tab_list, capture(&block), flush: true
    end
  
    def tab(title, **options)
      options[:id] ||= "tab_#{title.parameterize}"
      options[:state] = options[:active] ? "active" : "inactive"

      @_tabs << {title: title, id: options[:id]}
      render("components/ui/tabs/tab", title:, options: options)
    end
  
    def tab_panels(&block)
      content_for :tab_panels, capture(&block), flush: true
    end
  
    def tab_panel(**options, &block)
      options[:state] = options[:active] ? "active" : "inactive"

      content_for :panel, capture(&block), flush: true

      render("components/ui/tabs/panel", options: options)
    end
  end