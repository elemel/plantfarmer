local heart = require("heart")

local M = heart.class.newClass()

function M:init(game, config)
  self.game = assert(game)
  self.physicsDomain = assert(self.game.domains.physics)
  self.raySensorComponents = assert(self.game.componentManagers.raySensor)
  self.color = config.color or {0, 1, 0, 1}
  self.scale = config.scale or 1
end

function M:__call(viewportId)
  local r, g, b, a = love.graphics.getColor()
  love.graphics.setColor(self.color)

  local bodies = self.physicsDomain.bodies
  local contacts = self.raySensorComponents.contacts

  for id, localRay in pairs(self.raySensorComponents.localRays) do
    local body = bodies[id]
    local localX1, localY1, localX2, localY2 = unpack(localRay)

    local x1, y1 = body:getWorldPoint(localX1, localY1)
    local x2, y2 = body:getWorldPoint(localX2, localY2)

    local contact = contacts[id]

    if contact then
      love.graphics.line(x1, y1, contact.x, contact.y)

      love.graphics.line(
        contact.x,
        contact.y,

        contact.x + self.scale * contact.normalX,
        contact.y + self.scale * contact.normalY)

      love.graphics.line(
        contact.x - self.scale * contact.normalY,
        contact.y + self.scale * contact.normalX,

        contact.x + self.scale * contact.normalY,
        contact.y - self.scale * contact.normalX)
    else
      love.graphics.line(x1, y1, x2, y2)
    end
  end

  love.graphics.setColor(r, g, b, a)
end

return M
