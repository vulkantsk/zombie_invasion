-- CreateTable
CREATE TABLE "Player" (
    "steam_id" TEXT NOT NULL,
    "currency" INTEGER NOT NULL DEFAULT 0,
    "heroes" JSONB NOT NULL DEFAULT '{}',
    "items" JSONB NOT NULL DEFAULT '{}',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Player_pkey" PRIMARY KEY ("steam_id")
);

-- CreateTable
CREATE TABLE "Hero" (
    "name" TEXT NOT NULL,

    CONSTRAINT "Hero_pkey" PRIMARY KEY ("name")
);

-- CreateTable
CREATE TABLE "Match" (
    "id" SERIAL NOT NULL,
    "difficulty" TEXT NOT NULL,
    "wavesCleared" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "isWin" BOOLEAN NOT NULL DEFAULT false,
    "heroes" TEXT[] DEFAULT ARRAY[]::TEXT[],
    "wagerTotal" INTEGER NOT NULL DEFAULT 0,
    "wagerMultiplier" DOUBLE PRECISION NOT NULL DEFAULT 1.0,

    CONSTRAINT "Match_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MatchParticipation" (
    "playerId" TEXT NOT NULL,
    "matchId" INTEGER NOT NULL,
    "heroName" TEXT NOT NULL,

    CONSTRAINT "MatchParticipation_pkey" PRIMARY KEY ("playerId","matchId")
);

-- CreateIndex
CREATE UNIQUE INDEX "Player_steam_id_key" ON "Player"("steam_id");

-- AddForeignKey
ALTER TABLE "MatchParticipation" ADD CONSTRAINT "MatchParticipation_playerId_fkey" FOREIGN KEY ("playerId") REFERENCES "Player"("steam_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MatchParticipation" ADD CONSTRAINT "MatchParticipation_matchId_fkey" FOREIGN KEY ("matchId") REFERENCES "Match"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MatchParticipation" ADD CONSTRAINT "MatchParticipation_heroName_fkey" FOREIGN KEY ("heroName") REFERENCES "Hero"("name") ON DELETE RESTRICT ON UPDATE CASCADE;
