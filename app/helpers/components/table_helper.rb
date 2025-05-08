module Components::TableHelper
    def render_table(caption = nil, **options, &block)
      content_tag :table, options.merge(
        class: tw("w-full text-sm border-b border-2 border-gray-200", options[:class])
      ) do
        if caption.present?
          content_tag :caption, caption, class: "mt-4 text-sm text-muted-foreground " do
            capture(&block)
          end
        else
          capture(&block)
        end
      end
    end
  
    def table_head(**options, &block)
      content_tag :thead, options.merge(
        class: tw("[&_tr]:border-2 [&_tr]:border-gray-200", options[:class])
      ) do
        content_tag :tr, class: "border-2 border-gray-200 transition-colors hover:bg-muted/50 data-[state=selected]:bg-muted" do
          capture(&block)
        end
      end
    end
  
    def table_header(content = nil, **options, &block)
      content_tag :th, options.merge(
        class: tw("h-12 px-4 text-left text-black bg-gray-200 align-middle font-medium [&:has([role=checkbox])]:pr-0", options[:class])
      ) do
        if block
          capture(&block)
        else
          content
        end
      end
    end
  
    def table_body(**options, &block)
      content_tag :tbody, options.merge(
        class: tw("[&_tr:last-child]:border-0", options[:class])
      ), &block
    end
  
    def table_row(**options, &block)
      content_tag :tr, options.merge(
        class: tw("border-2 border-gray-200 transition-colors hover:bg-muted/50 data-[state=selected]:bg-muted", options[:class]),
      ), &block
    end
  
    def table_column(content = nil, **options, &block)
      content_tag :td, options.merge(
        class: tw("p-4 align-middle [&:has([role=checkbox])]:pr-0 font-medium", options[:class])
      ) do
        if block
          capture(&block)
        else
          content
        end
      end
    end
  end