function formatBytes(value, precision) {
    let suffix = [' b', ' kb', ' Mb', ' Gb', ' Tb', ' Pb', ' Eb', ' Zb', ' Yb']
    let div = 1024.0
    let divcount
    let result
    for (divcount = 0; value > div && divcount < 9; ++divcount) {
        value = value / div
    }
    if (value >= 10**precision) {
        result = Math.round(value)
    } else {
        result = value.toPrecision(precision)
        let splitIdx = result.indexOf('.')
        if (splitIdx !== -1) {
            while (result.length) {
                let lastChar = result[result.length - 1]
                if (lastChar === '0') {
                    result = result.slice(0, -1)
                    continue
                }
                if (lastChar === '.') {
                    result = result.slice(0, -1)
                }
                break
            }
        }
    }
    return result + suffix[divcount]
}

function movingAverage(getWindowSize) {
    let size = Math.max(1, getWindowSize ? getWindowSize() : 5)
    let buf = new Array(size)
    let idx = 0
    let filled = 0
    let sum = 0
    return {
        push(v) {
            if (filled < size) {
                buf[idx] = v
                sum += v
                idx = (idx + 1) % size
                filled++
            } else {
                const old = buf[idx]
                buf[idx] = v
                sum += (v - old)
                idx = (idx + 1) % size
            }
            return Math.trunc(sum / filled)
        },
    }
}

function calculateMax(getWindowSize) {
    let size = Math.max(1, getWindowSize ? getWindowSize() : 5)
    let buf = []
    let max_queue = []
    return {
        push(v) {
            buf.push(v)
            while (max_queue.length && max_queue[max_queue.length - 1] < v) max_queue.pop()
            max_queue.push(v)
            while (buf.length > size) {
                let old = buf.shift()
                if (max_queue.length && max_queue[0] === old) max_queue.shift()
            }
            return max_queue[0]
        },
    }
}
