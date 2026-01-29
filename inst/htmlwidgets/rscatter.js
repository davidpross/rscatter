HTMLWidgets.widget({

  name: 'rscatter',

  type: 'output',

  factory: function(el, width, height) {

    const container = document.createElement('div');
    container.className = 'rscatter-container';
    container.style.display = 'flex';
    container.style.gap = '12px';
    container.style.alignItems = 'stretch';
    container.style.width = '100%';
    container.style.height = '100%';

    const plotWrapper = document.createElement('div');
    plotWrapper.style.flex = '1 1 auto';
    plotWrapper.style.minWidth = 0;
    plotWrapper.style.minHeight = 0;

    const canvas = document.createElement('canvas');
    canvas.id = 'canvas';
    canvas.style.width = '100%';
    canvas.style.height = '100%';
    plotWrapper.appendChild(canvas);

    const legendContainer = document.createElement('div');
    legendContainer.className = 'rscatter-legend';
    legendContainer.style.display = 'none';
    legendContainer.style.minWidth = '140px';
    legendContainer.style.fontFamily = 'sans-serif';
    legendContainer.style.fontSize = '12px';
    legendContainer.style.lineHeight = '1.4';
    legendContainer.style.alignSelf = 'flex-start';

    container.appendChild(plotWrapper);
    container.appendChild(legendContainer);
    el.appendChild(container);

    var plot = rscatter.scatterplot(canvas)
    let currentPoints = null;

    return {

      renderValue: function(x) {

        // Helper function to find all point indices for a given category
        const getIndicesForCategory = (categoryIndex) => {
          if (!currentPoints || !Array.isArray(currentPoints.valueA)) {
            return [];
          }
          const indices = [];
          for (let i = 0; i < currentPoints.valueA.length; i++) {
            if (currentPoints.valueA[i] === categoryIndex) {
              indices.push(i);
            }
          }
          return indices;
        };
        
        // Helper function to determine if category is currently highlighted
        const isAnyActive = () => legendContainer.querySelector('[data-active="true"]') !== null;

        // Build legend if provided
        if (Array.isArray(x.options.legend) && x.options.legend.length > 0) {
          legendContainer.style.display = 'flex';
          legendContainer.style.flexDirection = 'column';
          legendContainer.replaceChildren();

          x.options.legend.forEach(entry => {
            const row = document.createElement('div');
            row.className = 'rscatter-row';
            row.style.display = 'flex';
            row.style.alignItems = 'center';
            row.style.gap = '8px';
            row.style.cursor = 'pointer';
            row.style.paddingLeft = '4px'; // Space for the indicator
            row.style.borderLeft = '3px solid transparent'; 
            row.style.transition = 'border-color 0.2s, opacity 0.2s'; // Smooth transition
            row.dataset.categoryIndex = entry.index;
            row.dataset.active = 'false';

            const swatch = document.createElement('span');
            swatch.style.display = 'inline-block';
            swatch.style.width = '12px';
            swatch.style.height = '12px';
            swatch.style.border = '1px solid rgba(0,0,0,0.2)';
            swatch.style.borderRadius = '2px';
            swatch.style.backgroundColor = entry.color;

            const label = document.createElement('span');
            label.textContent = entry.label;

            row.appendChild(swatch);
            row.appendChild(label);
            legendContainer.appendChild(row);

            // Mouse enter: highlight points for this category
            row.addEventListener('mouseenter', () => {
              // if any category is locked ignore hover
              if (isAnyActive()) return;
              
              // show selected
              row.style.borderLeftColor = entry.color;

              const indices = getIndicesForCategory(entry.index);
              if (indices.length > 0 && typeof plot.select === 'function') {
                plot.select(indices);
              }
            });

            // Mouse leave: if not locked (clicked), clear selection
            row.addEventListener('mouseleave', () => {
              // if any category is locked ignore hover
              if (isAnyActive()) return;
              
              // not selected
              row.style.borderLeftColor = 'transparent';

              if (typeof plot.select === 'function') {
                plot.select([]);
              }
            });

            // Click: toggle locked selection for this category
            row.addEventListener('click', () => {
              const isActive = row.dataset.active === 'true';
              const allRows = legendContainer.querySelectorAll('.rscatter-row');

              // Toggle this row's active state
              if (isActive) {
                // Was active, now deactivate
                row.dataset.active = 'false'
                allRows.forEach(el => {
                  el.style.opacity = '1.0';
                  el.style.borderLeftColor = 'transparent';
                });
                if (typeof plot.select === 'function') {
                  plot.select([]);
                }
              } else {
                // Activate and Dim
                allRows.forEach(el => {
                  const isCurrent = (el === row);
                  el.dataset.active = isCurrent ? 'true' : 'false';
                  el.style.opacity = isCurrent ? '1.0' : '0.5';
                  el.style.borderLeftColor = isCurrent ? entry.color : 'transparent';
                });
                const indices = getIndicesForCategory(entry.index);
                if (indices.length > 0 && typeof plot.select === 'function') {
                  plot.select(indices);
                }
              }
            });
          });
        } else {
          legendContainer.style.display = 'none';
          legendContainer.replaceChildren();
        }

        // Store points data for legend interactions
        currentPoints = x.points;

        // Draw the plot
        plot.draw({
          x: x.points.x,
          y: x.points.y,
          valueA: x.points.valueA
        })

        // Configure plot settings
        plot.set({
          keyMap: {},
          pointColorHover: "#000000",
          pointColor: x.options.color,
          pointSize: x.options.size,
          colorBy: x.options.colorBy,
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
