# -*- coding:utf-8; mode:ruby; -*-

#require 'cgi'
require 'ruby-graphviz'

module Jekyll
  class GraphvizBlock < Liquid::Block

    DIV_CLASS_ATTR = 'graphviz-wrapper'
    DEFAULT_GRAPH_NAME = "Graphviz"

    def initialize(tag_name, markup, tokens)
      super
      @tag_name = tag_name

      @title = markup or ""
      @title.strip!

      @src = ""
    end

    def render(context)
      code = super
      title = if @title.empty? then DEFAULT_GRAPH_NAME else @title end

      case @tag_name
      when 'graphviz'	then render_graphviz code
      when 'graph'	then render_graph 'graph', title, code
      when 'digraph'	then render_graph 'digraph', title, code
      else raise "unknown liquid tag name: #{@tag_name}"
      end
    end

    def render_graphviz(code)
      @src = code
      filter_for_inline_svg GraphViz.parse_string(code).output(:svg => String)
    end

    def filter_for_inline_svg(code)
      code = remove_declarations code
      code = remove_xmlns_attrs code
      code = add_desc_attrs code
      code = insert_desc_elements code
      code = wrap_with_div code
      return code
    end

    def remove_declarations(svg)
      svg.sub(/<!DOCTYPE .+?>/im,'').sub(/<\?xml .+?\?>/im,'')
    end

    def remove_xmlns_attrs(svg)
      svg.sub(%[xmlns="http://www.w3.org/2000/svg"], '')
        .sub(%[xmlns:xlink="http://www.w3.org/1999/xlink"], '')
    end

    def add_desc_attrs(svg)
      svg.sub!("<svg", %[<svg aria-label="#{CGI::escapeHTML @title}"])
      svg.sub!("<svg", %[<svg role="img"])

      return svg
    end

    def insert_desc_elements(svg)
      inserted_elements = %[<title>#{CGI::escapeHTML @title}</title>\n] +
        %[<desc>#{CGI::escapeHTML @src}</desc>\n]
      svg.sub!(/(<svg [^>]*>)/, "\\1\n#{inserted_elements}")

      return svg
    end

    def wrap_with_div(svg)
      %[<div class="#{DIV_CLASS_ATTR}">#{svg}</div>]
    end

    def render_graph(type, title, code)
      render_graphviz %[#{type} "#{title}" { #{code} }]
    end
  end
end

Liquid::Template.register_tag('graphviz', Jekyll::GraphvizBlock)
Liquid::Template.register_tag('graph', Jekyll::GraphvizBlock)
Liquid::Template.register_tag('digraph', Jekyll::GraphvizBlock)
