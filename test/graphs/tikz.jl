# tikz.jl.jl
# Julia Script

#=
Description: 
Author: konstantin
Date: 20.08.26
=#

function export_tikz(filename, data, A, t; threshold=0.5)

    locations = collect(1:data.location_count)
    time_windows = data.time_windows
    distance_matrix = data.distance_matrix

    arcs = [(i, j) for i in locations for j in locations if i != j]

    n = length(locations)

    open(filename, "w") do io

        # --------------------------------------------------
        # TikZ header
        # --------------------------------------------------

        println(io, raw"""
\documentclass{article}
\usepackage{tikz}

\begin{document}

\begin{tikzpicture}[
    location/.style={
        circle,
        draw,
        minimum size=1.4cm,
        inner sep=2pt,
        align=center,
        font=\small
    },
    depot/.style={
        circle,
        draw,
        double,
        minimum size=1.5cm,
        inner sep=2pt,
        align=center,
        font=\small
    },
    solution/.style={
        ->,
        thick,
        green!50!black,
        >=stealth,
        line width=1.2pt,
        shorten >=2pt
    },
    possible/.style={
        -,
        dashed,
        gray
    },
    edge label/.style={
        fill=white,
        inner sep=1.5pt,
        font=\scriptsize
    }
]
""")

        # --------------------------------------------------
        # Node positions
        # --------------------------------------------------

        # Alle Locations gleichmäßig auf einem Kreis verteilen
        m = length(locations)
        radius = max(3.0, 0.8 * m)

        for (k, i) in enumerate(locations)

            angle = deg2rad(90 + 360 * (k - 1) / m)

            x_pos = round(radius * cos(angle), digits=2)
            y_pos = round(radius * sin(angle), digits=2)

            arrival = round(value(t[i]), digits=2)

            if i == 1

                # Depot
                println(io, """
        \\node[depot] (L$i) at ($x_pos,$y_pos) {
            Depot\\\\
            {\\color{green!50!black}\$t=$arrival\$}
        };
        """)

            else

                from, to = time_windows[i]

                println(io, """
        \\node[location] (L$i) at ($x_pos,$y_pos) {
            $i\\\\
            {\\scriptsize\$t\\in[$from,$to]\$}\\\\
            {\\color{green!50!black}\$t=$arrival\$}
        };
        """)

            end
        end

        # --------------------------------------------------
        # Edges
        # --------------------------------------------------

        arc_set = Set(arcs)

        for (i, j) in arcs

            travel_time = distance_matrix[i, j]

            if value(A[i, j]) > threshold
                edge_style = "solution"
            else
                edge_style = "possible"
            end

            opposite_exists = (j, i) in arc_set

            if opposite_exists

                if i < j
                    bend = "bend left=12"
                else
                    bend = "bend right=12"
                end

                println(io,
                    """
        \\draw[$edge_style,$bend]
            (L$i) to node[edge label] {$travel_time} (L$j);
        """
                )

            else

                println(io,
                    """
        \\draw[$edge_style]
            (L$i) -- node[edge label] {$travel_time} (L$j);
        """
                )

            end

        end

        println(io, raw"""
\end{tikzpicture}
\end{document}
""")
    end
end