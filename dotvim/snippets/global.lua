local lipsum = [[
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam rhoncus quam quis euismod tincidunt. Vestibulum quis rhoncus mi. Ut ut dolor non tellus pulvinar commodo non in lorem. Integer varius, nibh ac facilisis rhoncus, metus metus viverra erat, faucibus scelerisque felis nisl quis velit. Maecenas porttitor justo nec finibus dapibus. Fusce ut est quis justo vestibulum bibendum in at turpis. Mauris finibus venenatis velit, volutpat hendrerit orci fermentum id.
Suspendisse sit amet congue neque. Aliquam vel fringilla lorem. Aenean tempor vestibulum enim, a vehicula odio pulvinar eget. Sed eu maximus erat. Nunc tincidunt est a scelerisque ultricies. Nunc blandit, lacus quis ultrices viverra, neque ante tincidunt ex, tempor feugiat sapien mi in velit. Aenean vel malesuada elit. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Nulla velit tortor, faucibus ut purus in, elementum volutpat est.
Pellentesque rutrum iaculis felis, eu facilisis nibh aliquam nec. Morbi vitae est ac est finibus iaculis. Donec at leo cursus, luctus turpis ac, sagittis mauris. Nam auctor, nisl et laoreet venenatis, massa justo auctor risus, sed eleifend nisi leo vel leo. Nullam pretium dui vel mauris laoreet tempor. Praesent sollicitudin convallis ligula, et consectetur felis vehicula quis. Morbi non ultricies lectus, quis rhoncus tortor. In ac felis libero.
Phasellus id pretium nisl, sed malesuada nunc. Integer lobortis odio vel felis consectetur pharetra. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Sed convallis eros at diam consectetur commodo. Sed et tellus et enim pretium convallis. Vivamus ultricies, felis quis porttitor varius, velit odio iaculis arcu, vitae porta velit est id mi. Aliquam erat volutpat. Aenean egestas vitae est vel viverra. Nullam tincidunt condimentum odio, ullamcorper venenatis velit vulputate eget. Maecenas sapien elit, fermentum bibendum tellus sit amet, eleifend hendrerit metus. Duis in auctor dui. Quisque dolor velit, eleifend vitae ultrices vitae, tincidunt sit amet diam. Curabitur et tristique purus. In nec diam ante. Suspendisse ipsum nisi, vestibulum id porta id, efficitur nec sem.
Maecenas eget erat vitae felis commodo viverra. Nulla nisl urna, dignissim blandit tempor sit amet, auctor mattis risus. Praesent vulputate nibh id elit maximus, nec commodo leo dictum. Mauris luctus velit ante, et mattis massa euismod eget. Nulla eget purus lorem. Nulla facilisi. Duis quis lobortis tellus. Nulla ullamcorper justo dolor, non posuere ipsum mattis laoreet.
]]

local result = {}

for line in lipsum:gmatch('[^\n]+') do
    local count = #result + 1
    table.insert(result, {
        prefix = 'lipsum' .. tostring(count),
        desc = 'Lorem Ipsum ' .. tostring(count),
        body = line,
    })
end

return result
