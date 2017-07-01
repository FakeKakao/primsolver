require 'logger'
$log = Logger.new(STDOUT)
# FATAL, ERROR, WARN, INFO, DEBUG
$log.level = Logger::DEBUG

require_relative 'pqueue'

class Graph
    attr_reader :num_vertices, :adj_matrix

    class InvalidGraphError < StandardError
        def initialize(msg = "Invalid Graph")
            super
        end
    end

    def initialize(graph_string = "0")
        @num_vertices = 0
        @adj_matrix = []
        graph_string = graph_string.lines.map {|l| l.chomp}

        $log.debug "Number of vertices : #{@num_vertices}"
        inc_node graph_string[0].to_i

        (graph_string.drop 1).each do |e|
            matched = e.match(/\((\d+),\s*(\d+),\s*(\d+)\)/)
            src = matched[1].to_i
            dst = matched[2].to_i
            weight = matched[3].to_i
            $log.debug "Edge : #{src} -> #{dst} with weight #{weight}"
            add_edge src, dst, weight
        end
    end

    def inc_node(num = 1)
        begin
            raise InvalidGraphError, "Cannot decrease the number of nodes." if num < 1
            for i in (0...@num_vertices)
                @adj_matrix[i][@num_vertices + num - 1] = nil
            end
            for i in (@num_vertices...@num_vertices + num)
                @adj_matrix[i] = Array.new(@num_vertices + num)
            end
            @num_vertices += num
            return true
        rescue InavlidGraphError => ex
            return false
        end
    end

    def add_edge(src, dst, weight)
        begin
            raise InvalidGraphError, "Adding invalid edge." if src > @num_vertices || dst > @num_vertices || src < 1 || dst < 1
            @adj_matrix[src-1][dst-1] = weight
            @adj_matrix[dst-1][src-1] = weight
            return true
        rescue InvalidGraphError => ex
            return false
        end
    end

    def to_s
        ret = "#{@num_vertices}\n"
        for i in (0...@num_vertices)
            for j in (i...@num_vertices)
                ret << "(#{i+1}, #{j+1}, #{@adj_matrix[i][j]})\n" unless @adj_matrix[i][j].nil?
            end
        end
        return ret
    end

    def dfs(v, visited)
        visited[v] = true
        for i in (0...@num_vertices)
            unless visited[i] || adj_matrix[v][i].nil?
                visited = dfs(i, visited)
            end
        end
        return visited
    end

    def connected?
        dfs(0, Array.new(@num_vertices, false)).each do |t|
            return false unless t
        end
        return true
    end

    def prim
        return nil unless connected?

        mst = []
        visited = Array.new(@num_vertices, false)
        key = Array.new(@num_vertices)
        parent = Array.new(@num_vertices)
        key[0] = 0
        que = Pqueue.new(key)

        while !que.empty?
            min = que.min
            visited[min] = true
            mst << [parent[min], min]

            for i in (0...@num_vertices)
                unless (visited[i] || adj_matrix[min][i].nil? || (!key[i].nil? && key[i] <= adj_matrix[min][i]))
                    key[i] = adj_matrix[min][i]
                    parent[i] = min
                    que.update(i, key[i])
                end
            end
        end
        
        ret = ""
        weight = 0
        (mst.drop 1).each do |e|
            s, d = e
            weight += adj_matrix[s][d]
            ret << "(#{s+1}, #{d+1}, #{adj_matrix[s][d]})\n"
        end
        ret << "#{weight}\n"

        return ret
    end
end
