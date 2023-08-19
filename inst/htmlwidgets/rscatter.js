HTMLWidgets.widget({

  name: 'rscatter',

  type: 'output',

  factory: function(el, width, height) {

    const canvas = document.createElement('canvas');
    canvas.id = 'canvas';
    canvas.width = width;
    canvas.height = height;
    el.appendChild(canvas);
    
    var plot = rscatter.scatterplot(canvas, width, height)

    return {

      renderValue: function(x) {

        plot.draw(x.points)

      },

      resize: function(width, height) {

        // TODO: code to re-render the widget with a new size

      },

      plot: plot

    };
  }
});