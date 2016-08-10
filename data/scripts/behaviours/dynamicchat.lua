DynamicChat = Class(BehaviourNode, function(self, inst, chatlinesfn, child)
    BehaviourNode._ctor(self, "DynamicChat", {child})

    self.inst = inst
    self.chatlinesfn = chatlinesfn
    self.nextchattime = nil
end)

function DynamicChat:Visit()
    local child = self.children[1]

    child:Visit()
    self.status = child.status

    local chatlines = self.chatlinesfn(self.inst)
    if self.status == RUNNING and chatlines ~= nil then
        local t = GetTime()
        if self.nextchattime == nil or t > self.nextchattime then
            if type(chatlines) == "table" then
                --legacy, will only show on host
                local str = chatlines[math.random(#chatlines)]
                self.inst.components.talker:Say(str)
            else
                --Will be networked if talker:MakeChatter() was initialized
                local strtbl = STRINGS[chatlines]
                if strtbl ~= nil then
                    local strid = math.random(#strtbl)
                    self.inst.components.talker:Chatter(chatlines, strid)
                end
            end
            self.nextchattime = t + 10 + math.random() * 10
        end
        if self.nextchattime ~= nil then
            self:Sleep(self.nextchattime - t)
        end
    end
end

