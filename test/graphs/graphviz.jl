# graphviz.jl.jl
# Julia Script

#=
Description: 
Author: konstantin
Date: 19.08.26
=#

function export_graphviz(filename, data, A, t; threshold = 0.5)
    locations = 1:data.location_count
    time_windows = data.time_windows
    distance_matrix = data.distance_matrix

    arcs = [(i, j) for i in locations for j in locations if i != j]

    open(filename, "w") do io

        println(io, "digraph G {")

        # --------------------------------------------------
        # Graph appearance
        # --------------------------------------------------

        println(io, "    rankdir=LR;")
        println(io, "    splines=polyline;")
        println(io, "    concentrate=false;")
        println(io, "    bgcolor=\"white\";")
        println(io, "    graph [pad=0.3, nodesep=0.6, ranksep=1.0];")
        println(io, "    edge [fontname=\"Arial\", fontsize=9];")
        println(io)

        # --------------------------------------------------
        # Nodes
        # --------------------------------------------------

        for i in locations

            arrival = round(value(t[i]), digits=2)

            if i == 1

                println(io, """
                    $i [
                        shape=plain,
                        label=<
                            <table
                                border="2"
                                cellborder="0"
                                cellspacing="0"
                                cellpadding="2"
                                bgcolor="#EEEEEE"
                            >
                                <tr>
                                    <td><b>Depot</b></td>
                                </tr>
                                <tr>
                                    <td>
                                        <font color="#4C9A5F">
                                            t=$arrival
                                        </font>
                                    </td>
                                </tr>
                            </table>
                        >
                    ];
                """)

            else

                from, to = time_windows[i]

                println(io, """
                    $i [
                        shape=plain,
                        label=<
                            <table
                                border="2"
                                cellborder="0"
                                cellspacing="0"
                                cellpadding="2"
                                bgcolor="white"
                            >
                                <tr>
                                    <td><b>$i</b></td>
                                </tr>
                                <tr>
                                    <td>
                                        t ∈ [$from,$to]
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <font color="#4C9A5F">
                                            t=$arrival
                                        </font>
                                    </td>
                                </tr>
                            </table>
                        >
                    ];
                """)

            end
        end

        println(io)

        # --------------------------------------------------
        # Edges
        # --------------------------------------------------

        for (i, j) in arcs

            selected = value(A[i, j]) > threshold
            travel_time = distance_matrix[i, j]

            if selected

                println(io,
                    """    $i -> $j [
                        label="$travel_time",
                        color="#4C9A5F",
                        fontcolor="#4C9A5F",
                        penwidth=3,
                        style=solid,
                        arrowsize=1.1
                    ];"""
                )

            else

                println(io,
                    """    $i -> $j [
                        label="$travel_time",
                        color="#AAAAAA",
                        fontcolor="#888888",
                        penwidth=1,
                        style=dashed
                    ];"""
                )

            end
        end

        println(io, "}")
    end
end