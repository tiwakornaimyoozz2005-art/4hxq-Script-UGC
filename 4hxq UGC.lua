return function(env)
local C = env.C
local _cs = env._cs
local _nvL = env._nvL
local createInstance = env.createInstance
local makeFloatingPanel = env.makeFloatingPanel
local makePanelTitleBar = env.makePanelTitleBar
	_G._ugcPanel = nil

	local function _makeAbSection(parent, yOff, label)
		local lbl = createInstance("TextLabel", {
			Parent = parent,
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 14, 0, yOff),
			Size = UDim2.new(1, -28, 0, 18),
			Font = Enum.Font.GothamBold,
			TextSize = 10,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			Text = label,
			TextXAlignment = Enum.TextXAlignment.Left,
			ZIndex = 153,
		})
	end

	local function _makeAbCard(parent, yOff, h)
		local card = createInstance("Frame", {
			Parent = parent,
			BackgroundColor3 = C.CARD,
			BackgroundTransparency = 0.55,
			BorderSizePixel = 0,
			Position = UDim2.new(0, 12, 0, yOff),
			Size = UDim2.new(1, -24, 0, h),
			ZIndex = 152,
		})
		createInstance("UICorner", { Parent = card, CornerRadius = UDim.new(0, 6) })
		local cs = createInstance("UIStroke", { Parent = card, Color = C.DIV, Thickness = 1, Transparency = 0.55 })
		return card
	end

	local function _setup()
		local PANEL_W, PANEL_H = 280, 520
		_G._ugcPanel = makeFloatingPanel(PANEL_W, PANEL_H, 0.5, 0.45)
		_G._ugcPanel.Name = "UGCPanel"
		_G._ugcPanel.BackgroundTransparency = 0

		local abBar = makePanelTitleBar(_G._ugcPanel, "UGC Emotes", function()
			_G._ugcPanel.Visible = false
		end)
		_cs.makePanelDraggable(_G._ugcPanel, abBar)

		local pk = _G._nv_popC
		local ugcBody, BW = pk.body(_G._ugcPanel)

		local searchBox = pk.field(ugcBody, UDim2.fromOffset(0, 0), UDim2.new(1, -92, 0, 36), "Search name or ID", "", "search")
		local stopBtn = pk.button(ugcBody, BW - 84, 0, 84, 36, "Stop", "stop", "red")

		pk.caption(ugcBody, 52, "Add custom emote")
		local addCard = pk.group(ugcBody, 74, 104)
		local customNameBox = pk.field(addCard, UDim2.fromOffset(12, 12), UDim2.new(0.5, -16, 0, 36), "Name", "")
		local customIdBox = pk.field(addCard, UDim2.new(0.5, 4, 0, 12), UDim2.new(0.5, -16, 0, 36), "Emote ID", "")
		local addBtn = pk.pill(addCard, 12, 56, BW - 24, 36, "Save emote")

		pk.caption(ugcBody, 192, "Emotes")
		local listCard = pk.group(ugcBody, 214, 0)
		listCard.Size = UDim2.new(1, 0, 1, -214)

		local scroll = createInstance("ScrollingFrame", {
			Parent = listCard,
			Size = UDim2.new(1, -12, 1, -12),
			Position = UDim2.new(0, 6, 0, 6),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ScrollBarThickness = 0,
			ScrollBarImageColor3 = C.TEXT,
			ZIndex = 21,
		})

		local currentAnimTrack = nil
		local function playEmote(id)
			local char = _nvL.lp.Character
			if not char then return end
			local hum = char:FindFirstChildOfClass("Humanoid")
			if not hum then return end
			local animator = hum:FindFirstChildOfClass("Animator")
			if not animator then
				animator = createInstance("Animator", { Parent = hum })
			end

			if currentAnimTrack then
				currentAnimTrack:Stop()
				currentAnimTrack = nil
			end

			local anim = nil
			local s, objs = pcall(function() return game:GetObjects("rbxassetid://" .. id) end)
			if s and objs and #objs > 0 then
				local item = objs[1]
				if item:IsA("Animation") then
					anim = item
				else
					anim = item:FindFirstChildWhichIsA("Animation", true)
				end
			end

			if not anim then
				anim = createInstance("Animation", { AnimationId = "rbxassetid://" .. id })
			end

			currentAnimTrack = animator:LoadAnimation(anim)
			currentAnimTrack.Priority = Enum.AnimationPriority.Action4
			currentAnimTrack.Looped = true
			currentAnimTrack:Play()
		end

		stopBtn.MouseButton1Click:Connect(function()
			if currentAnimTrack then
				currentAnimTrack:Stop()
				currentAnimTrack = nil
			end
			local char = _nvL.lp.Character
			local hum = char and char:FindFirstChildOfClass("Humanoid")
			local animator = hum and hum:FindFirstChildOfClass("Animator")
			if animator then
				for _, track in animator:GetPlayingAnimationTracks() do
					pcall(function() track:Stop(0.1) end)
				end
			end
		end)

		local emotesList = {
{name = "Salute", id = 3360689775},
{name = "Applaud", id = 5915779043},
{name = "Tilt", id = 3360692915},
{name = "Yungblud Happier Jump", id = 15610015346},
{name = "Baby Queen - Bouncy Twirl", id = 14353423348},
{name = "Baby Queen - Face Frame", id = 14353421343},
{name = "Godlike", id = 3823158750},
{name = "KATSEYE - Touch", id = 139021427684680},
{name = "Biblically Accurate Emote", id = 133596366979822},
{name = "Rambunctious", id = 108128682361404},
{name = "Moon Walk", id = 79127989560307},
{name = "Bored", id = 5230661597},
{name = "Baby Queen - Strut", id = 14353425085},
{name = "d4vd - Backflip", id = 15694504637},
{name = "[Original] It's Gangnam Style!", id = 104142334418357},
{name = "Mae Stephens - Piano Hands", id = 16553249658},
{name = "Alo Yoga Pose - Lotus Position", id = 12507097350},
{name = "Cuco - Levitate", id = 15698511500},
{name = "Sleep", id = 4689362868},
{name = "Floating on clouds", id = 111426928948833},
{name = "The Weeknd Starboy Strut", id = 130245358716273},
{name = "Secret Handshake Dance", id = 120642514156293},
{name = "Victory Dance", id = 15506503658},
{name = "Shy", id = 3576717965},
{name = "Nyan Nyan!", id = 73796726960568},
{name = "Kicking Feet Sit", id = 78758922757947},
{name = "/e fly", id = 93511411593120},
{name = "R15 Death (Accurate)", id = 114899970878842},
{name = "Hero Landing", id = 5104377791},
{name = "Floss Dance", id = 5917570207},
{name = "Xaviersobased Emote", id = 131763631172236},
{name = "California Girl Dance", id = 132074413582912},
{name = "Olivia Rodrigo Head Bop", id = 15554010118},
{name = "Bubbly Sit", id = 112758073578333},
{name = "Monkey", id = 3716636630},
{name = "Onion", id = 123015710605336},
{name = "Curtsy", id = 4646306583},
{name = "Caramell", id = 85936805522788},
{name = "TWICE Feel Special", id = 14900153406},
{name = "Deltarune - Tenna Dance", id = 102492229412911},
{name = "Flopping Fish", id = 133142324349281},
{name = "Frosty Flair - Tommy Hilfiger", id = 10214406616},
{name = "Cute crouch", id = 120224229260879},
{name = "Festive Dance", id = 15679955281},
{name = "Sad", id = 4849502101},
{name = "V Pose - Tommy Hilfiger", id = 10214418283},
{name = "Garry's Dance", id = 92853367837757},
{name = "Make You Mine", id = 104485625389237},
{name = "Phut On", id = 139830733782518},
{name = "Tank Transformation", id = 132382355371060},
{name = "Scenario - LOVE SCENARIO", id = 103046131635200},
{name = "Bone Chillin' Bop", id = 15123050663},
{name = "Shattered", id = 124305244640379},
{name = "how did he hit every beat", id = 134311528115559},
{name = "Elton John - Heart Shuffle", id = 17748346932},
{name = "Quiet Waves", id = 7466046574},
{name = "Caramell Dansen", id = 96557878503341},
{name = "Dead", id = 139859849852362},
{name = "HUGO Let's Drive!", id = 17360720445},
{name = "Skibidi Toilet - Titan Speakerman Laser Spin", id = 103102322875221},
{name = "Shrug", id = 3576968026},
{name = "Gangnam Style", id = 130998336536045},
{name = "Helicopter Spin", id = 84555218084038},
{name = "Popular", id = 71302743123422},
{name = "DearALICE - Ariana", id = 133765015173412},
{name = "2 Phut Hon Dance", id = 115319301809339},
{name = "Be Not Afraid", id = 70635223083942},
{name = "Sturdy Dance - Ice Spice", id = 17746270218},
{name = "griddy", id = 129149402922241},
{name = "Hello", id = 3576686446},
{name = "Gangnam Style", id = 113547795536875},
{name = "Sit", id = 126614732606871},
{name = "Greatest", id = 3762654854},
{name = "HIPMOTION - Amaarae", id = 16572756230},
{name = "Sol de Janeiro - Samba", id = 16276506814},
{name = "Point2", id = 3576823880},
{name = "Family Man Death Pose", id = 78459263478161},
{name = "TWICE LIKEY", id = 14900151704},
{name = "Stadium", id = 3360686498},
{name = "Nicki Minaj Starships", id = 15571540519},
{name = "Cower", id = 4940597758},
{name = "Elton John - Elevate", id = 11394056822},
{name = "Virtual Singer Dance", id = 117734400993750},
{name = "Teto Territory", id = 97263450325496},
{name = "Haha", id = 4102315500},
{name = "Chappell Roan HOT TO GO!", id = 79312439851071},
{name = "Electro Swing", id = 105851216004006},
{name = "Mesmerizer", id = 92707348383277},
{name = "Deltarune - Tenna Swing Dance", id = 103139492736941},
{name = "Nicki Minaj Boom Boom Boom", id = 15571538346},
{name = "Olivia Rodrigo Fall Back to Float", id = 15554016057},
{name = "Floating", id = 70615023659736},
{name = "/e hidden animation", id = 136740085081295},
{name = "Helicopter", id = 119431985170060},
{name = "No-Clip/Speed Glitch", id = 87141651594092},
{name = "Beauty Touchdown", id = 16303091119},
{name = "Dizzy", id = 3934986896},
{name = "rolling crybaby", id = 130726889233022},
{name = "Elton John - Heart Skip", id = 11309263077},
{name = "Emote Loading. Please Wait... spinning Robloxian", id = 84511772437190},
{name = "Baby Queen - Air Guitar & Knee Slide", id = 14353417553},
{name = "Paris Hilton - Sliving For The Groove", id = 15392927897},
{name = "TWICE Takedown pt 1 from Kpop Demon Hunters", id = 94796833553521},
{name = "peter griffin death pose", id = 120437019363089},
{name = "Flex Walk", id = 15506506103},
{name = "Proud to be Expendable - Pressure", id = 90608224567833},
{name = "Team USA Breaking Emote", id = 18526338976},
{name = "Default Dance", id = 99818263438846},
{name = "Dani's Gangnam Style", id = 103197720369544},
{name = "TV Time Dance", id = 75017857395637},
{name = "Fashion Roadkill", id = 73683655527605},
{name = "Paris Hilton - Iconic IT-Grrrl", id = 15392932768},
{name = "Thanos Happy Jump - Squid Game", id = 82217023310738},
{name = "Possessed", id = 102610758906338},
{name = "Rat Dance", id = 95323795166399},
{name = "Gangnam Style", id = 127562607220778},
{name = "Helicopter", id = 129132611803602},
{name = "Dia Delicia Dance", id = 82345302788133},
{name = "Paris Hilton - Checking My Angles", id = 15392937495},
{name = "Zombie", id = 4212496830},
{name = "Best Mates EMOTE [LIMITED]", id = 113016438012253},
{name = "[Aura Farm] Wall Lean Idle", id = 110537281410647},
{name = "ILLIT - Magnetic", id = 92903522317071},
{name = "It's TV Time!", id = 122899100558551},
{name = "Rambunctious", id = 75528418031928},
{name = "Gojo Floating", id = 103040723950430},
{name = "Kickn around", id = 70788193750089},
{name = "High Wave", id = 5915776835},
{name = "Jojo", id = 84195923658292},
{name = "[ Limited]  HEADLESS EMOTE", id = 110731335896907},
{name = "Hip Bounce", id = 139271706064778},
{name = "Happy", id = 4849499887},
{name = "M3GAN's Dance", id = 127271798262177},
{name = "ONCE HOP HOP!", id = 104304182344567},
{name = "TWICE Takedown pt 2 from KPop Demon Hunters", id = 85623000473425},
{name = "Pickle Rick Dance", id = 84067050907557},
{name = "Caramelldansen", id = 86982022610765},
{name = "Im Talm Bout Innit", id = 117301403779781},
{name = "Maraschino Step", id = 84822284410814},
{name = "Laying Down - Daydreaming", id = 89174456614428},
{name = "OH WHO IS YOU", id = 91023138078288},
{name = "Prince Of Egypt Dance / What You Want", id = 107978036345855},
{name = "Golden Freddy Pose", id = 71363859760586},
{name = "Default Dance OG", id = 80877772569772},
{name = "HEADLESS HOOPER", id = 80436375269036},
{name = "Sit", id = 93262662842394},
{name = "6 7 Transformation", id = 75703899901487},
{name = "Stray Kids Walkin On Water", id = 100773414188482},
{name = "Become A Car!", id = 131544122623505},
{name = "Death Pose", id = 99005087791705},
{name = "MM2 Fake Dead", id = 132384701706046},
{name = "Discombobulated", id = 129916107176034},
{name = "Angry Stomp", id = 88598010609888},
{name = "xavier so based emote", id = 132508867759412},
{name = "Hide", id = 121167704249654},
{name = "Floating Human Spinner (LIMITED)", id = 137873580964093},
{name = "Belly Dance", id = 76700167742736},
{name = "levitate", id = 87826892596287},
{name = "Fake Dead (Troll Emote)", id = 70972410468289},
{name = "Young-hee Head Spin - Squid Game", id = 134615135651900},
{name = "Tommy - Archer", id = 13823339506},
{name = "IShowSpeed Dance", id = 109755476052324},
{name = "Skibidi", id = 124828909173982},
{name = "Fast Hands", id = 4272351660},
{name = "Speed Glitch+", id = 137006085779408},
{name = "Weird Spin", id = 89633087256727},
{name = "Fake Death (BEST)", id = 125032357496729},
{name = "Hug", id = 81177294287826},
{name = "P.B.J.T.", id = 88721672617892},
{name = "Xaviersobased Jig", id = 121259524934987},
{name = "PARROT PARTY DANCE", id = 121067808279598},
{name = "Show Dem Wrists - KSI", id = 7202898984},
{name = "Macarena", id = 120377619472998},
{name = "Jumping Wave", id = 4940602656},
{name = "Torture Dance", id = 94663026124741},
{name = "Get Sturdy", id = 120896030393583},
{name = "Sponge Dance", id = 137261874619072},
{name = "Plane", id = 119746055344304},
{name = "Cute Laying Down", id = 78620443286892},
{name = "Pose for the Pic", id = 108922782921118},
{name = "Heart Hands Pose 3.0", id = 131221550165951},
{name = "Caramel Hip Sway", id = 119454955259757},
{name = "Wake Up Call - KSI", id = 7202900159},
{name = "Griddy", id = 79752538807060},
{name = "head spin", id = 140466682449054},
{name = "Cute Sit", id = 96405718067779},
{name = "Power Blast", id = 4849497510},
{name = "Blue Shirt Guy Dancing", id = 89413575288931},
{name = "Aura Farm", id = 112924687333965},
{name = "Car Transformation", id = 100782362883099},
{name = "Space Dance", id = 102323907950469},
{name = "The Old Jitterbug", id = 110521067391235},
{name = "Druski Shuffle", id = 111304332281521},
{name = "Soda Pop - Saja Boys", id = 133600250245899},
{name = "Rasputin  Boney M.", id = 133477296392756},
{name = "[Aura Farm] Sit Idle", id = 122949892043249},
{name = "Jackpot Groove", id = 82739386299071},
{name = "Dreamer", id = 80422524668416},
{name = "Subject Three / AI Cat Chinese Dance", id = 97968838104258},
{name = "Macarena", id = 91274761264433},
{name = "Bodybuilder", id = 3994130516},
{name = "Dolphin Dance", id = 5938365243},
{name = "Jumpstyle", id = 99563839802389},
{name = "Caramelldansen", id = 85361710130557},
{name = "Ishowspeed shake", id = 74646784680842},
{name = "Beckon", id = 5230615437},
{name = "Magical Pose", id = 135489824748823},
{name = "Rat Dance", id = 98603994713783},
{name = "Baby Queen - Dramatic Bow", id = 14353419229},
{name = "Floating", id = 84052327668385},
{name = "Spin my Head", id = 97999370392804},
{name = "Rat Dance", id = 94319114655768},
{name = "Mr. Ant Tennas Dance - DELTARUNE", id = 86849720336961},
{name = "Die Lit!", id = 124754178569693},
{name = "Helicopter", id = 80544397800234},
{name = "MONSTER MASH", id = 100532972764499},
{name = "What You Want", id = 88922397617835},
{name = "Garry's Dance", id = 115810068374896},
{name = "Human Snake", id = 75842745124834},
{name = "Hakari Dance", id = 94451497143711},
{name = "Saja Boy Pose - Jinu", id = 73556976257737},
{name = "PROXIMA", id = 81390693780805},
{name = "Mini Kong", id = 17000058939},
{name = "BlockyKick Dance", id = 97629500912487},
{name = "Griddy", id = 112949099442762},
{name = "Jinu Pose - Saja Boys", id = 130641944883645},
{name = "Dep", id = 108474079699304},
{name = "Line Dance", id = 4049646104},
{name = "criss cross sit", id = 91423783304464},
{name = "[] Chill Sit", id = 90524692306889},
{name = "Rock n Roll", id = 15506496093},
{name = "GAG IT DEATH DROP", id = 134737246939931},
{name = "I'm Going To Die Here - Pressure", id = 128658037413893},
{name = "Relaxed Sit", id = 99568437064777},
{name = "Stargazing", id = 83018514370428},
{name = "ALTGO - Couldnt Care Less", id = 92859581691366},
{name = "Casual Sit", id = 94534169345613},
{name = "Paris Hilton Sanasa", id = 16126526506},
{name = "Caramel dance", id = 140037329261678},
{name = "Go Mufasa", id = 94118707925458},
{name = "Dani's BIRDBRAIN", id = 105730788757021},
{name = "Koto Nai Meme Dance", id = 91927498467600},
{name = "Hide Hidden Box Invisible Camo Emote Small tiny", id = 117450501566142},
{name = "Baby Dance", id = 4272484885},
{name = "Oppa Gangnam Style", id = 88024974500195},
{name = "Boxing Punch - KSI", id = 7202896732},
{name = "Watching silly videos (Or texting)", id = 128792127841374},
{name = "xavier so based dance", id = 87756443172440},
{name = "BirdBrain Teto", id = 116770268279002},
{name = "Hiding Human Box", id = 124935873390035},
{name = "Kicking Feet And Blushing", id = 94121796810251},
{name = "Hood Dance", id = 91945243106968},
{name = "Rolling Stones Guitar Strum", id = 18148839527},
{name = "Confused", id = 4940592718},
{name = "Sidekicks - George Ezra", id = 10370922566},
{name = "JUMP K-POP Dance Choreo", id = 111481711726876},
{name = "Big Papa Squat", id = 114443541753616},
{name = "Cursed Floating Rotating Head", id = 96927087453178},
{name = "Cute Lie", id = 114695623925996},
{name = "24 Hour Cinderella", id = 82407315928589},
{name = "What You Want", id = 100576647621125},
{name = "cute sit", id = 131875333242836},
{name = "Fashionable", id = 3576745472},
{name = "Otsukare Summer Dance", id = 79681561839536},
{name = "[BEST] Orange Justice", id = 133160900449608},
{name = "Ay-Yo Dance Move - NCT 127", id = 12804173616},
{name = "Cute Feet Kicks", id = 131643212415034},
{name = "SUMMER DANCE", id = 138929851868463},
{name = "[CUTE] Kayah's Pose", id = 124031351335869},
{name = "Elton John - Rock Out", id = 11753545334},
{name = "what happened bro", id = 137987340488409},
{name = "Territory", id = 114428584463004},
{name = "[HOT] Caramelldansen", id = 119868674917432},
{name = "Fastest Speedster Run", id = 133948663586698},
{name = "RAT DANCE", id = 133461102795137},
{name = "Tenna's Cabbage Dance", id = 140406175549428},
{name = "head walks away", id = 109664116234926},
{name = "MM2 Sit Emote", id = 103323241937359},
{name = "Head Banger", id = 81621254772462},
{name = "Shy Cute Pose", id = 133999268647970},
{name = "Im a mystery", id = 110833764398565},
{name = "Gojo Honored One", id = 121643381580730},
{name = "ISHOWSPEED DANCE", id = 82664964457620},
{name = "kawaii magical girl kpop idle pose", id = 126228947948058},
{name = "Jawny - Stomp", id = 16392120020},
{name = "Playing Dead", id = 131499177714385},
{name = "cute kawaii girly idle pose 2", id = 90831367043789},
{name = "Griffin Fall", id = 82749804870046},
{name = "Floating Relaxation", id = 78085025505710},
{name = "Ballroom Dance", id = 127507691649322},
{name = "Cute Kpop Poses", id = 90929823390861},
{name = "Candy Emote", id = 75773776265985},
{name = "Snow angels", id = 135922662345048},
{name = "Samba", id = 6869813008},
{name = "Folding, Hide [Animated]", id = 124481227791432},
{name = "Default Dance", id = 78792474294700},
{name = "Rock On", id = 5915782672},
{name = "Elevation", id = 134928834792631},
{name = "L Dance", id = 140333668677501},
{name = "cat loaf", id = 70978791982917},
{name = "Peter Griffin Pose (Family Guy Death Pose)", id = 134521545276284},
{name = "Beat Da Koto Nai", id = 130655908439646},
{name = "Proxima Creatura", id = 76503754262527},
{name = "talmbout INNIT", id = 78164771288203},
{name = "Torture Dance", id = 81780730637211},
{name = "Falling back Death", id = 99565933541178},
{name = "Popular", id = 76080208205057},
{name = "Wall Lean", id = 88969192102242},
{name = "Company Dance", id = 84061944625677},
{name = "Skinwalker", id = 82761302670038},
{name = "Macarena", id = 73946479113094},
{name = "Bring it around", id = 77975534812454},
{name = "Cute Anime Bouncy Dance", id = 107091254142209},
{name = "Jackpot Dance", id = 81005824258133},
{name = "Shimmer (ORIGINAL)", id = 114092281019046},
{name = "Cat Dance", id = 85051384683771},
{name = "Mr. Skier", id = 124664935927071},
{name = "Honored One", id = 128800625861321},
{name = "Caffeinated", id = 99453823712550},
{name = "Snoop Dance", id = 107012521566800},
{name = "Celebrate", id = 3994127840},
{name = "Unemployment Dance", id = 96847244958186},
{name = "Do That Thang", id = 98064631733787},
{name = "Classic R6 Dance Potion", id = 90334065717691},
{name = "Speed Try not to laugh", id = 101425980133974},
{name = "[BEST] Caramell Dansen", id = 84306405425879},
{name = "Rin", id = 78107150834426},
{name = "Hide And Seek", id = 110932994930898},
{name = "OOF", id = 89721517985713},
{name = "Rat dance", id = 121838903053629},
{name = "ericdoa - dance", id = 15698510244},
{name = "Whimsical Laying Down", id = 123282496097076},
{name = "Classic Retro Jump", id = 119095524735341},
{name = "Firework", id = 108099880348985},
{name = "Arsenal: Parker Pride", id = 107300313701198},
{name = "Head toss", id = 116838897398428},
{name = "Monster mash emote R15", id = 76250099012024},
{name = "JUMP - BP (KPOP)", id = 122404842843791},
{name = "E Girl", id = 84932726570047},
{name = "Wanna play?", id = 16646438742},
{name = "Dance If You're Peak", id = 138171891850624},
{name = "Sturdy NYC Dance", id = 122687759897103},
{name = "TMNT Dance", id = 18665886405},
{name = "chinese dance", id = 108408215437382},
{name = "Mr \"ant\" Tenna's Kick - Deltarune", id = 71912700800803},
{name = "Sit", id = 86588737455577},
{name = "Rampage (Lonely Lonely)", id = 101397505086633},
{name = "Girly Outfit-Check", id = 115584191221260},
{name = "Infinite R6 Backflips", id = 124970376117840},
{name = "Agree", id = 4849487550},
{name = "Push Up", id = 109763881381610},
{name = "AI Cat Dance", id = 131987997650304},
{name = "Gojo Honored One Floating Flying Toji Itadori Yuji", id = 85347533889715},
{name = "Horror Slow Turn", id = 131873902790140},
{name = "Deltarune Tenna Dance", id = 73715378215546},
{name = "Miku Beam Emote", id = 135545153917736},
{name = "Hugging Idle", id = 76904955984085},
{name = "Play Dead Troll Trick Emote mm2", id = 89115363544461},
{name = "Whip Nae Nae", id = 123955691598090},
{name = "Scenario - Roblox", id = 128771561752851},
{name = "Deactivated Sit", id = 125478215073174},
{name = "Shuffling", id = 115925652377890},
{name = "Rock Out - Bebe Rexha", id = 18225077553},
{name = "67 Transformation [NEW]", id = 96251764572550},
{name = "Dougie Meme Dance", id = 119256963154827},
{name = "sinking", id = 89227290900829},
{name = "Caramelldansen", id = 102348999290457},
{name = "float", id = 104491001585941},
{name = "Aura RNG Fly Idle", id = 78755795767408},
{name = "Uprise - Tommy Hilfiger", id = 10275057230},
{name = "/e dance2", id = 124072098165199},
{name = "TENNA", id = 84624658497647},
{name = "I Wanna Run Away", id = 129128109582733},
{name = "Superman Emote", id = 85748580511408},
{name = "Rat Dance", id = 124783960722552},
{name = "Hug", id = 102822553233176},
{name = "[BEST] Caramell Dansen", id = 87275228219621},
{name = "Jumpstyle Dance", id = 89614983665331},
{name = "Worm", id = 127882676467351},
{name = "Everybody Loves Me (Dougie)", id = 114756515400742},
{name = "Penguin dance", id = 84881027922455},
{name = "Dropper", id = 130358790702800},
{name = "Folding", id = 79314952379576},
{name = "Shadow DIO Jojo Pose", id = 119673857864183},
{name = "2013 Dance", id = 110226648097430},
{name = "Golden Freddy Glitch Emote", id = 122463450997235},
{name = "Play Dead", id = 135564949884122}
}

		local favEmotes = {}
		local function loadFavEmotes()
			pcall(function()
				if readfile and isfile and isfile("Novoline/ugc_favs.json") then
					local data = game:GetService("HttpService"):JSONDecode(readfile("Novoline/ugc_favs.json"))
					for _, id in data do
						favEmotes[tostring(id)] = true
					end
				end
			end)
		end
		local function saveFavEmotes()
			pcall(function()
				if writefile then
					local data = {}
					for id, state in favEmotes do
						if state then data[#data + 1] = tonumber(id) end
					end
					if not isfolder("Novoline") then makefolder("Novoline") end
					writefile("Novoline/ugc_favs.json", game:GetService("HttpService"):JSONEncode(data))
				end
			end)
		end
		loadFavEmotes()

		local function loadCustomEmotes()
			pcall(function()
				if readfile and isfile and isfile("Novoline/custom_emotes.json") then
					local data = game:GetService("HttpService"):JSONDecode(readfile("Novoline/custom_emotes.json"))
					for _, em in data do
						emotesList[#emotesList + 1] = {name = tostring(em.name), id = tonumber(em.id)}
					end
				end
			end)
		end
		loadCustomEmotes()

		local ugcPool = {}
		local ITEM_H = 40
		local currentSorted = {}

		local function createUgcBtn()
			local btn = createInstance("TextButton", {
				Parent = scroll,
				Size = UDim2.new(1, 0, 0, ITEM_H),
				BackgroundColor3 = Color3.new(1, 1, 1),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Font = Enum.Font.GothamBold,
				TextSize = 13,
				TextColor3 = C.TEXT,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextTruncate = Enum.TextTruncate.AtEnd,
				ZIndex = 21,
				AutoButtonColor = false,
			})
			createInstance("UICorner", { Parent = btn, CornerRadius = UDim.new(0, 12) })

			local pad = createInstance("UIPadding", { Parent = btn, PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 68) })

			local starBtn = createInstance("ImageButton", { Parent = btn, Size = UDim2.new(0, 18, 0, 18), AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 56, 0.5, 0), BackgroundTransparency = 1, ZIndex = 22 })
			_G._nv_lazyFluent(starBtn, "star")

			local copyBtn = createInstance("ImageButton", {
				Parent = btn,
				Size = UDim2.new(0, 18, 0, 18),
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, 28, 0.5, 0),
				BackgroundTransparency = 1,
				ImageColor3 = Color3.fromRGB(120, 120, 120),
				ZIndex = 22,
			})
			_G._nv_lazyFluent(copyBtn, "copy")

			btn.MouseEnter:Connect(function()
				game:GetService("TweenService"):Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.95}):Play()
			end)
			btn.MouseLeave:Connect(function()
				game:GetService("TweenService"):Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
			end)
			copyBtn.MouseEnter:Connect(function() game:GetService("TweenService"):Create(copyBtn, TweenInfo.new(0.2), {ImageColor3 = Color3.new(1,1,1)}):Play() end)
			copyBtn.MouseLeave:Connect(function() game:GetService("TweenService"):Create(copyBtn, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(120,120,120)}):Play() end)

			return { btn = btn, starBtn = starBtn, copyBtn = copyBtn, conns = {} }
		end

		local function updateVirtualList()
			local y = scroll.CanvasPosition.Y
			local viewport = scroll.AbsoluteWindowSize.Y
			if viewport <= 0 then viewport = 480 end

			local startIndex = math.max(1, math.floor(y / ITEM_H) + 1)
			local endIndex = math.min(#currentSorted, startIndex + math.ceil(viewport / ITEM_H) + 2)

			local poolIdx = 1
			for i = startIndex, endIndex do
				if not ugcPool[poolIdx] then ugcPool[poolIdx] = createUgcBtn() end
				local p = ugcPool[poolIdx]
				local em = currentSorted[i]

				p.btn.Visible = true
				p.btn.Position = UDim2.new(0, 0, 0, (i - 1) * ITEM_H)
				p.btn.Text = em.name

				local isFav = favEmotes[tostring(em.id)]
				p.starBtn.ImageColor3 = isFav and Color3.fromRGB(245, 197, 66) or Color3.fromRGB(96, 96, 102)

				for _, c in p.conns do c:Disconnect() end
				table.clear(p.conns)

				p.conns[1] = p.starBtn.MouseButton1Click:Connect(function()
					favEmotes[tostring(em.id)] = not favEmotes[tostring(em.id)]
					saveFavEmotes()
					updateVirtualList()
				end)

				p.conns[2] = p.copyBtn.MouseButton1Click:Connect(function()
					if setclipboard then
						setclipboard(tostring(em.id))
						_nvL.notify("UGC Emotes", "Copied ID: " .. em.id)
					else
						_nvL.notify("UGC Emotes", "Executor doesn't support setclipboard")
					end
				end)

				p.conns[3] = p.btn.MouseButton1Click:Connect(function()
					playEmote(em.id)
					_nvL.notify("UGC Emotes", "Playing " .. em.name)
				end)

				poolIdx = poolIdx + 1
			end

			for i = poolIdx, #ugcPool do
				ugcPool[i].btn.Visible = false
			end
		end

		scroll:GetPropertyChangedSignal("CanvasPosition"):Connect(updateVirtualList)
		scroll:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(updateVirtualList)

		local function populateList(filter)
			filter = filter and filter:lower() or ""

			local sorted = {}
			for _, em in emotesList do
				if filter == "" or em.name:lower():find(filter) or tostring(em.id):find(filter) then
					table.insert(sorted, em)
				end
			end

			table.sort(sorted, function(a, b)
				local aF = favEmotes[tostring(a.id)] and 1 or 0
				local bF = favEmotes[tostring(b.id)] and 1 or 0
				if aF ~= bF then
					return aF > bF
				else
					return a.name:lower() < b.name:lower()
				end
			end)

			currentSorted = sorted
			scroll.CanvasSize = UDim2.new(0, 0, 0, #currentSorted * ITEM_H)
			updateVirtualList()
		end

		addBtn.MouseButton1Click:Connect(function()
			local n = customNameBox.Text
			local i = tonumber(customIdBox.Text)
			if n and n ~= "" and i then
				emotesList[#emotesList + 1] = {name = n, id = i}
				pcall(function()
					local custom = {}
					if readfile and isfile and isfile("Novoline/custom_emotes.json") then
						custom = game:GetService("HttpService"):JSONDecode(readfile("Novoline/custom_emotes.json"))
					end
					custom[#custom + 1] = {name = n, id = i}
					if writefile then
						if not isfolder("Novoline") then makefolder("Novoline") end
						writefile("Novoline/custom_emotes.json", game:GetService("HttpService"):JSONEncode(custom))
					end
				end)
				customNameBox.Text = ""
				customIdBox.Text = ""
				_nvL.notify("UGC Emotes", "Saved custom emote!")
				populateList(searchBox.Text)
			else
				_nvL.notify("UGC Emotes", "Invalid Name or ID")
			end
		end)

		searchBox.FocusLost:Connect(function(enterPressed)
			local txt = searchBox.Text
			if enterPressed and tonumber(txt) then
				playEmote(tonumber(txt))
				_nvL.notify("UGC Emotes", "Playing Custom ID " .. txt)
			end
		end)

		searchBox:GetPropertyChangedSignal("Text"):Connect(function()
			populateList(searchBox.Text)
		end)

		populateList()
	end

	_setup()
	pcall(function() _nvL.applyThemeTo(_G._ugcPanel) end)
end
