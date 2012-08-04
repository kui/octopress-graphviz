Jekyll/Octopress Graphviz Plugin
=======================================================

a Jekyll/Octopress plugin which convert a graphviz source code to a svg element
with an alternative text for HTML5.

Example
--------------------------------------------

if you write: 

	{% graph non-directed graph %}
	a -- b
	b -- c
	c -- a
	{% endgraph %}

then it's converted to: 

	<svg role="img" aria-label="non-directed graph" width="89pt" height="188pt" viewBox="0.00 0.00 89.00 188.00">
	<title>non-directed graph</title>
	<desc>graph "non-directed graph" { 
	a -- b
	b -- c
	c -- a
	}</desc>
	 
	<g id="graph1" class="graph" transform="scale(1 1) rotate(0) translate(4 184)">
	 
	 ...
	
	</g>
	</svg>

![a graphviz result](http://25.media.tumblr.com/tumblr_m7p27myHck1qz64n4o1_250.png)

Installation
---------------------------

In your terminal:

	cd <your_octopress>/plugins
	wget https://raw.github.com/kui/octopress-graphviz/master/graphviz_block.rb
