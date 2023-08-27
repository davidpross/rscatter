HTMLWidgets.widget({

  name: 'rscatter',

  type: 'output',

  factory: function(el, width, height) {

    const canvas = document.createElement('canvas');
    canvas.id = 'canvas';
    // canvas.style.backgroundColor = "black";
    el.appendChild(canvas);
    
    var plot = rscatter.scatterplot(canvas)

    return {

      renderValue: function(x) {

        plot.draw(x.points)
        plot.set({
          keyMap: {},
        })
        plot.set({
          pointColorHover: x.options.color,
          pointColor: x.options.color,
          pointSize: x.options.size,
        })
        
        if (x.options.opacity) {
          plot.set({
            opacity: x.options.opacity,
          })
        } else {
          plot.set({
            opacityBy: "density",
          })
        }

      },

      resize: function(width, height) {

        plot.set({ width, height });

      },

      plot: plot

    };
  }
});