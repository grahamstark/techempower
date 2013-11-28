#!/bin/bash

for i in {0..10000..1}
do
        `wget -q localhost:8091/db`
done


