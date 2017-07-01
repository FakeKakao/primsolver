class Element
    include Comparable

    attr_accessor :value, :key

    def initialize(value, key)
        @value, @key = value, key
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
        @array = []
        @map = []
        @index = 0
        arr.each_with_index do |k, n|
            insert(n, k)
        end
    end

    def min
        return nil if @index.zero?

        ret = @array[0]
        @index -= 1
        @array[0] = @array[@index]
        @map[ret.value] = nil
        @array[@index] = nil
        min_heapify(0)
        return ret.value
    end

    def insert(n, k)
        @array[@index] = Element.new(n, nil)
        @map[n] = @index
        decrease_key(@index, k)
        @index += 1
        return nil
    end

    private def min_heapify(i)
        l = 2 * i + 1
        r = 2 * i + 2
        min = i
        if l < @index && @array[l] < @array[i]
            min = l
        end
        if r < @index && @array[r] < @array[min]
            min = r
        end

        if min != i
            @map[@array[i].value], @map[@array[min].value] = min, i
            @array[i], @array[min] = @array[min], @array[i]
            min_heapify(min)
        end
    end

    def update(n, k)
        return decrease_key(@map[n], k)
    end

    def decrease_key(i, k)
        if !@array[i].key.nil? && @array[i].key < k
            return false
        end

        @array[i].key = k

        while i > 0 && @array[(i-1)/2] > @array[i]
            pi = (i-1)/2
            @map[@array[i].value], @map[@array[pi].value] = pi, i
            @array[i], @array[pi] = @array[pi], @array[i]
            i = pi
        end
        return true
    end

    def empty?
        return @index.zero?
    end
end
