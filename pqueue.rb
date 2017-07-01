class Element
    include Comparable

    attr_accessor :node, :key

    def initialize(node, key)
        @node, @key = node, key
    end

    def <=>(other)
        if @key.nil?
            if other.key.nil?
                return 0
            else
                return 1
            end
        else
            if other.key.nil?
                return -1
            else
                @key <=> other.key
            end
        end
    end
end

class Pqueue
    def initialize(arr = [])
        @map = []
        @heap = []
        @index = 0 # place to insert new element

        arr.each_with_index do |k, n|
            insert(n, k)
        end
    end

    def min
        return nil if @index.zero?

        ret = @heap[0]
        @index -= 1
        @map[ret.node] = nil
        @map[@heap[@index].node] = 0
        @heap[0] = @heap[@index]
        @heap[@index] = nil
        min_heapify(0)
        return ret.node
    end

    def insert(n, k)
        @map[n] = @index
        @heap[@index] = Element.new(n, nil)
        decrease_key(@index, k)
        @index += 1
        return nil
    end

    private def min_heapify(i)
        return false unless i < @index

        l = 2 * i + 1
        r = 2 * i + 2
        min = i
        if l < @index && @heap[l] < @heap[min]
            min = l
        end
        if r < @index && @heap[r] < @heap[min]
            min = r
        end

        if min != i
            @map[@heap[i].node], @map[@heap[min].node] = min, i
            @heap[i], @heap[min] = @heap[min], @heap[i]
            min_heapify(min)
        end
        return true
    end

    def update(n, k)
        return decrease_key(@map[n], k)
    end

    private def decrease_key(i, k)
        return false if !@heap[i].key.nil? && @heap[i].key < k

        @heap[i].key = k
        while i > 0 && @heap[(i-1)/2] > @heap[i]
            p = (i-1)/2
            @map[@heap[i].node], @map[@heap[p].node] = p, i
            @heap[i], @heap[p] = @heap[p], @heap[i]
            i = p
        end
        return true
    end

    def empty?
        return @index.zero?
    end
end
