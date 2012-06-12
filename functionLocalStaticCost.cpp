#include <stdio.h>
#include <pthread.h>
#include <string.h>
#include <vector>

struct UniqueIdGenerator
{
  int val;
  UniqueIdGenerator() : val(0) { }

  int GetNextId()
  { 
    return __sync_fetch_and_add(&val, 1);
  }
};

static UniqueIdGenerator GEN;
__attribute__ ((noinline)) static int GetIdGlobal()
{
  return GEN.GetNextId();
}

__attribute__ ((noinline)) static int GetIdLocal()
{
  static UniqueIdGenerator gen;
  return gen.GetNextId();
}

static const int NUM_CYCLES = 100000000;
void *RunGlobal(void *)
{
  for (int i = 0; i < NUM_CYCLES; i++)
    GetIdGlobal();

  return NULL;
}

void *RunLocal(void *)
{
  for (int i = 0; i < NUM_CYCLES; i++)
    GetIdLocal();

  return NULL;
}

int main(int argc, char **argv)
{
  if (argc != 3)
  {
    printf("Usage: %s <num threads> <local|global>\n", argv[0]);
    return -1;
  }

  int numThrds = atoi(argv[1]);
  std::vector<pthread_t> threads(numThrds);

  if (!strcmp(argv[2], "local"))
  {
    for (int i = 0; i < numThrds; ++i)
      pthread_create(&threads[i], NULL, RunLocal, NULL);
  }
  else
  {
    for (int i = 0; i < numThrds; ++i)
      pthread_create(&threads[i], NULL, RunGlobal, NULL);
  }  

  for (int i = 0; i < numThrds; ++i)
    pthread_join(threads[i], NULL);

  return 0;
}
